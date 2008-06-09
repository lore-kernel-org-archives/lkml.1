Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbYFIUNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbYFIUNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 16:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbYFIUNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 16:13:08 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64650 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754082AbYFIUNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 16:13:07 -0400
Date: Mon, 9 Jun 2008 21:12:12 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Glauber Costa <gcosta@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, hugh@veritas.com
Subject: Re: [PATCH 11/15] x86: move enabling of io_apic to prepare_cpus
In-Reply-To: <484D8813.4040807@redhat.com>
Message-ID: <Pine.LNX.4.55.0806092058550.26593@cliff.in.clinika.pl>
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
 <1213021018-14159-2-git-send-email-gcosta@redhat.com>
 <1213021018-14159-3-git-send-email-gcosta@redhat.com>
 <1213021018-14159-4-git-send-email-gcosta@redhat.com>
 <1213021018-14159-5-git-send-email-gcosta@redhat.com>
 <1213021018-14159-6-git-send-email-gcosta@redhat.com>
 <1213021018-14159-7-git-send-email-gcosta@redhat.com>
 <1213021018-14159-8-git-send-email-gcosta@redhat.com>
 <1213021018-14159-9-git-send-email-gcosta@redhat.com>
 <1213021018-14159-10-git-send-email-gcosta@redhat.com>
 <1213021018-14159-11-git-send-email-gcosta@redhat.com>
 <1213021018-14159-12-git-send-email-gcosta@redhat.com>
 <Pine.LNX.4.55.0806091620250.26593@cliff.in.clinika.pl> <484D8813.4040807@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008, Glauber Costa wrote:

> This one does enable_IO_APIC in the init_uniprocessor too, and should 
> account for the !smp case.

 Hmm, it looks a little bit better, but why do you want to call
enable_IO_APIC() separately in the first place?  There is a comment
stating: "Enable IO APIC before setting up error vector," but why is it
needed on 64-bit systems?  Especially as the very same system may run a
32-bit kernel and then it suddenly would not have to do this anymore?  
Strange...

 Also since you are cleaning up this code -- why don't you actually take
the opportunity and get rid of the horrible #ifdefs interspersed
throughout?

  Maciej
