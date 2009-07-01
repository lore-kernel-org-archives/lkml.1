Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbZGAHER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbZGAHER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 03:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbZGAHED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 03:04:03 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:27264 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbZGAHED convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 03:04:03 -0400
Message-Id: <4A4B2683020000780000862F@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 01 Jul 2009 08:04:03 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Cc: <tony.luck@intel.com>, "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Tim Abbott" <tabbott@mit.edu>, <sam@ravnborg.org>,
       "Paul Mackerras" <paulus@samba.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] also discard .*init sections after module
	 initialization
References: <4A4A19C60200007800008353@vpn.id2.novell.com>
 <200907011452.26720.rusty@rustcorp.com.au>
In-Reply-To: <200907011452.26720.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Rusty Russell <rusty@rustcorp.com.au> 01.07.09 07:22 >>>
>On Tue, 30 Jun 2009 09:27:26 pm Jan Beulich wrote:
>> Just like .init, these sections are supposed to be unneeded after init,
>> and modpost warns about improper section references anyway.
>
>Tim Abbot had a section renaming patch, for -ffunction-sections.  Can we kill 
>two birds with one stone and have a unique string for init sections, and 
>another for exit sections?

Not sure, would need to see what that patch does first. And then, the patch
here doesn't do any renaming.

>> Likewise
>> for .*exit which, other than .exit, aren't needed for the module unload
>> path.
>
>Currently true, but I can't see that being true in general.

Why? .*exit sections deal with device/memory/CPU hot remove, which is
orthogonal to module unload.

Jan

