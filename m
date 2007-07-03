Return-Path: <linux-kernel-owner+w=401wt.eu-S1758826AbXGCFpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826AbXGCFpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 01:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757748AbXGCFpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 01:45:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758381AbXGCFpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 01:45:08 -0400
Date: Tue, 3 Jul 2007 01:44:55 -0400
From: Dave Jones <davej@redhat.com>
To: Len Brown <lenb@kernel.org>
Cc: Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix empty macros in acpi.
Message-ID: <20070703054455.GB32110@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Len Brown <lenb@kernel.org>, Al Viro <viro@ftp.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070612233309.GA24251@redhat.com> <20070613002115.GA28778@redhat.com> <20070613002631.GL21478@ftp.linux.org.uk> <200707030122.47747.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707030122.47747.lenb@kernel.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 01:22:47AM -0400, Len Brown wrote:

 > whelp, it seems that the reason for this patch is this:
 > 
 > #define DBG()
 > 
 > if(...)
 > 	DBG();
 > next_c_statement
 > 
 > which turns into
 > if(...) ;
 > next_c_statement
 > 
 > But since there is an intervening ';', this code is still functionally correct
 > and a decent compiler will delete the test altogether, yes?

Right, gcc does generate the correct code.

 > So is there some real problem here that I missed,
 > or is this to make some code-checking tool that I don't have happy?

Out of curiousity, I thought I'd see what was lurking in a -Wextra
build a while back. It's 99.9% noise, but a lot of it is trivial stuff
like this.

	Dave

-- 
http://www.codemonkey.org.uk
