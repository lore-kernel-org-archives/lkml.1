Return-Path: <linux-kernel-owner+w=401wt.eu-S934718AbYCFQRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934718AbYCFQRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 11:17:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761177AbYCFQQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 11:16:58 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:43273 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760928AbYCFQQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 11:16:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:references:from:date:in-reply-to:message-id:user-agent:mime-version:content-type:sender;
        b=Gv/vffJOTkryfVLCNSHm9dBAzmeeT/qeXsY/JRYi/jPBJwf7YfbxtsdRXLZ38my0WwFSJAZE2BlDOqu7uZSH5mkmcVMo9FvFpVfxsIwoaee3BAOmGB2tdFb+rATsYFaL/V7IOYJFvIOZ1mRocG8vgJjjN+s1NHetzOIkck5wipA=
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-boot: don't request VBE2 information
References: <1204797405-18059-1-git-send-email-jacmet@sunsite.dk>
	<47D00AC0.8010805@zytor.com>
From: Peter Korsgaard <jacmet@sunsite.dk>
Date: Thu, 06 Mar 2008 17:16:52 +0100
In-Reply-To: <47D00AC0.8010805@zytor.com> (H. Peter Anvin's message of "Thu\, 06 Mar 2008 07\:16\:16 -0800")
Message-ID: <87skz3g74b.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "H" == H Peter Anvin <hpa@zytor.com> writes:

 >> Disassembing the video BIOS shows that it overflows the vesa_general_info
 >> structure when VBE2 data is requested because the source addresses for the
 >> information strings which get strcpy'ed to the buffer lie outside the 32K
 >> BIOS code (and hence contain long sequences of 0xff's).
 >> 

 H> I'm slightly concerned about this, because we *do* use VBE2 data -
 H> just not the stuff that this particular BIOS seems to key on (and
 H> break.)

Well, we use the version info to know if we can request EDID data, but
otherwise I don't see any VBE2 stuff in vesa_general_info used.

A VBE2+ compatible BIOS should still put the correct version number in
the VBE info block even if you don't request VBE2 data (E.G. the
version gets set to 3.0 independently of VBE2 or not in the disasm I
sent).

 H> On the other hand, until we get an example on something that breaks
 H> with the change, we might as well try it, since we have an example on
 H> something that breaks with it.  We should monitor carefully, though.

Great. This was how the old asm version used to do it as well.

-- 
Bye, Peter Korsgaard
