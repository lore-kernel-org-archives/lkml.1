Return-Path: <linux-kernel-owner+w=401wt.eu-S935243AbXJQRqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935243AbXJQRqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759808AbXJQRqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:46:08 -0400
Received: from mga10.intel.com ([192.55.52.92]:35569 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761070AbXJQRqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:46:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,290,1188802800"; 
   d="scan'208";a="176600476"
Date: Wed, 17 Oct 2007 10:45:26 -0700
From: Mark Gross <mgross@linux.intel.com>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
Message-ID: <20071017174526.GA26758@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20071014190128.6e3cdb44@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071014190128.6e3cdb44@bree.surriel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2007 at 07:01:28PM -0400, Rik van Riel wrote:
> The kernel newbies community often gets inquiries from CS students who
> need a project for their studies and would like to do something with
> the Linux kernel, but would also like their code to be useful to the
> community afterwards.
> 
> In order to make it easier for them, I am trying to put together a
> page with projects that:
> - Are self contained enough that the students can implement the
>   project by themselves, since that is often a university requirement.
> - Are self contained enough that Linux could merge the code (maybe
>   with additional changes) after the student has been working on it
>   for a few months.
> - Are large enough to qualify as a student project, luckily there is
>   flexibility here since we get inquiries for anything from 6 week
>   projects to 6 month projects.
> 
> If you have ideas on what projects would be useful, please add them
> to this page (or email me):
> 
> http://kernelnewbies.org/KernelProjects
>

How about a static code tool that will check for initialization races?
yesterday I found a lurker bug in some of my code that wouldn't have
been exposed had not tripped over it.  I wrote some infrastructure code
that initializes its lists and notification trees in late_init.  

Then I found  out that there was as client of my infrastructure calling
my register API at core_init time.  It didn't crash / fail noticeably,
but wasn't correct, because at that time I was using a static array. 
When I changed my code to use an array of pointers instead it went boom!
(FWIW I've fixed this issue for now...)

It made me feel uneasy how that issue got by un-noticed and I worry that
there could be more like it.  A tool to scan the code for boot up init
calls and check for any callers into any module for entry before the
module is fully initialized.  

--mgross
