Return-Path: <linux-kernel-owner+w=401wt.eu-S966205AbXFGBBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966205AbXFGBBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 21:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756420AbXFGBBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 21:01:05 -0400
Received: from n9.bullet.re3.yahoo.com ([68.142.237.94]:48683 "HELO
	n9.bullet.re3.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755463AbXFGBBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 21:01:04 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 187614.15395.bm@rrr4.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=zH9Kpl4aFLd/l4Vp3qBqzl0dpIf8qSgLiDciiQu+wGtw6G6JjbdJ2TnJtYWpMpeFAffj3+lzgo+T/rAmNvGgPIK7zWY73z1nMM40h64wisY6RVQ3IVPclbpr43G9g9OKepnxtJt7MFvfyQoRuvRo+4z//jSY/NwssNlAPXGX21k=;
X-YMail-OSG: 1qR9CfkVM1nY9sFqtcymm_GPew2KNV1SgLasTM95s_lwSugchKDERNPcL8U5sbCWC.t9effvuhziMJafLRpgn03jlGw9mmWuKZL9rhoaOiCqNrzAvyqg6MHk69lw03VE
Date: Wed, 6 Jun 2007 18:00:24 -0700 (PDT)
From: Justin Treon <justin_treon_lkml@yahoo.com>
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
To: Jared Hulbert <jaredeh@gmail.com>, carsteno@de.ibm.com
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
In-Reply-To: <6934efce0706061201o13709f3fu4aa12e6a40fe7e06@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <478654.90355.qm@web59313.mail.re1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Jared Hulbert <jaredeh@gmail.com> wrote:
> The vma->flags = 1875 = 0x753
> 
> This is:
> VM_READ
> VM_WRITE
> VM_MAYREAD
> VM_MAYEXEC
> VM_GROWSDOWN
> VM_GROWSUP
> VM_PFNMAP
> 
There was a mistake in Jared's previous post in this
thread. The vm_flags were already in hex, i.e. 0x1875

The settings were:
VM_READ
VM_EXEC
VM_MAYREAD
VM_MAYWRITE
VM_MAYEXEC
VM_DENYWRITE
VM_EXECUTABLE

A possible problem source is that VM_PFNMAP is not set. 
Thus when vm_normal_page is called there is no associated
struct page.  

Justin Treon




      ____________________________________________________________________________________
Park yourself in front of a world of choices in alternative vehicles. Visit the Yahoo! Auto Green Center.
http://autos.yahoo.com/green_center/ 

