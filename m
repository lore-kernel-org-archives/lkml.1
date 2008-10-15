Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbYJORz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbYJORz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 13:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbYJORzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 13:55:18 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:29347 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbYJORzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 13:55:16 -0400
X-IronPort-AV: E=Sophos;i="4.33,417,1220227200"; 
   d="scan'208";a="175804551"
From: Roland Dreier <rdreier@cisco.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH] fastboot: Introduce an asynchronous function call mechanism
References: <20081012194427.2e21c22e@infradead.org>
	<20081015014117.faff3a61.akpm@linux-foundation.org>
	<20081015075246.2e1610f3@infradead.org>
	<20081015095905.41219c9d.akpm@linux-foundation.org>
	<20081015175252.GA10600@x200.localdomain>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 15 Oct 2008 10:55:15 -0700
In-Reply-To: <20081015175252.GA10600@x200.localdomain> (Alexey Dobriyan's
	message of "Wed, 15 Oct 2008 21:52:52 +0400")
Message-ID: <aday70pd9q4.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Oct 2008 17:55:15.0636 (UTC) FILETIME=[2DBF8F40:01C92EEF]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > I was actually "?"ing at the "= 0".  I thought that would be obvious
 > > but it's whizzed past two people so far :(
 > 
 > Is there evidence that some gccs will not add such variable to .bss?
 > 
 > Because "= 0;" is more readable.

From: http://gcc.gnu.org/gcc-3.3/changes.html

  GCC 3.3.1 automatically places zero-initialized variables in the .bss
  section on some operating systems. Versions of GNU Emacs up to (and
  including) 21.3 will not work correctly when using this optimization;
  you can use -fno-zero-initialized-in-bss to disable it.

so presumably gcc 3.2 (which we still support, right?) does not do this
(and puts such variables in .data).

 - R.
