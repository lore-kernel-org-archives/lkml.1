Return-Path: <linux-kernel-owner+w=401wt.eu-S1752415AbYAWLVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbYAWLVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 06:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYAWLVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 06:21:22 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:29032 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbYAWLVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 06:21:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=P3knBLADX6KOycV/9+xjOIM0OpLxp86fy0IxeVoeE/JkOQbh5Y7DEef51xnijOe8Pxxe1xVRemfCnYnWKW3MQBqU1qmyKFZ59EvdVPrROQc3ojqrMaW/BD3OPib1x8Vn6kqd/W4hvfIs/SfTd+vIB51azs/YjUOYzpeFX9j6hUw=
Subject: Re: [PATCH] x86: make nx_enabled conditional on CONFIG_X86_PAE
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Ian Campbell <ijc@hellion.org.uk>,
       =?iso-8859-1?q??==?iso-8859-1?q? Mika
	 =?ISO-8859-1?Q?Penttil=E4=3F=3D?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <p73odbdlyiu.fsf@crumb.suse.de>
References: <1200758937-22386-2-git-send-email-ijc@hellion.org.uk>
	 <47939363.8040603@kolumbus.fi>
	 <1200950633.15491.21.camel@cthulhu.hellion.org.uk>
	 <479510CE.7010706@zytor.com>
	 <1200951996.15491.28.camel@cthulhu.hellion.org.uk>
	 <479551FD.5040801@zytor.com>
	 <1201023401.5643.52.camel@localhost.localdomain>
	 <479634A9.1090908@zytor.com>
	 <1201031325.15491.66.camel@cthulhu.hellion.org.uk>
	 <47964B7B.9000905@zytor.com> <20080122203611.GA12892@elte.hu>
	 <1201035611.16972.61.camel@brick>  <p73odbdlyiu.fsf@crumb.suse.de>
Content-Type: text/plain
Date: Wed, 23 Jan 2008 03:21:31 -0800
Message-Id: <1201087291.16972.107.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-23 at 09:46 +0100, Andi Kleen wrote:
> Harvey Harrison <harvey.harrison@gmail.com> writes:
> 
> > nx_enabled can only be set to non-zero when CONFIG_X86_PAE is
> > set.  The only use not currently inside a CONFIG_X86_PAE block
> > is the definition, the declaration and a conditional unlikely
> > test in fault_32.c (is_prefetch).
> 
> The variable is pretty useless anyways; it can be probably
> replaced with (__supported_pte_mask & _PAGE_NX). Just make
> sure that the disable option still works, but that should
> be possible with some care.
> 
> So if you feel the need to clean up things here convert it 
> to using that. That will automatically be optimized away
> on !PAE too because _PAGE_NX is 0 there.
> 

Noted, will do.

Harvey

