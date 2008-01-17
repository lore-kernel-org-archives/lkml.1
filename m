Return-Path: <linux-kernel-owner+w=401wt.eu-S1756274AbYAQTOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbYAQTOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 14:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYAQTN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 14:13:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:61837 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbYAQTN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 14:13:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WM9pWMWcBilM1u+5iT81lE5wSlLdkGsiLaKZsE+/YiudXZDBQ1x8k92w+VXfdgJFUeYoI7pIdkdSJy6DAgnpeh0h7u4ULDl54WgFOqJBCSfXzCjqxMH8SdcTWpx8VA4PnRQjrlS4Ig8Z+ryjz1ZN4/rtZjg3I4Dv2eK+lzqdb6A=
Message-ID: <519a8b110801171113y20a3bedfg446e29a30712a26d@mail.gmail.com>
Date: Thu, 17 Jan 2008 20:13:54 +0100
From: xming <xmingske@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Cannot boot xen DomU > 2.6.23.1
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>
In-Reply-To: <478F8D22.60004@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <519a8b110801170813h96b8f2by795e6d8b72a00ba4@mail.gmail.com>
	 <478F8D22.60004@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 17, 2008 6:15 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Uh, that's very strange.  That patch fixes an outright bug, unless
> you're using one specific changeset out of the xen-unstable mercurial
> tree.  What version of Xen are you using?  Is it one you've built from
> xenbits, or distributed by someone?  Are you using a 32 or 64 bit xen/dom0?
>
> I don't understand where the "too much console activity" message comes
> from.  Could you post an actual cut'n'paste of the message, or a
> screenshot?  Are you using a serial console on your dom0?

I am running Xen 3.1.2 from Gentoo, tried 3.1.1. 32 bit PAE as I wrote in the
previous post

> > I am running Xen 3.1.2 PAE

I never had any problem (at least THIS problem) with any PV DomU (2.6.18,
2.6.20, 2.6.21, 2.6.23-RCs and 2.6.23.1). The problem started with 2.6.23.3
and today I finally found time to track it down.

This only affects PV domU, so I don't undestand your question about serial
console of Dom0.

The symptom is (with a lot of subjective judgment) when there is a lot (or
too quick) output on the console of the domU (hvc0 connected with either
"xm crea file.cfg -c" or "xm cons id") the whole PV domU hangs. It will
really hang at random places, sometimes right after init and sometime
after I logged in and just generate some ouput (on hvc0) like "find /". IIRC
I have never seen a hang before init.

When it hangs there is no output on console any more and network to
that domU is dead too, nothing affects dom0. "xm list" still reports the
domU as "r", nothing special in the logs (of dom0 xen logs) and no
OOPS nor panic reported in the domU. It's seem that it's running in a
infinite loop.

So, I can make screenshots, but they won't tell you anything, the is no
message, it's just dead.

Gentoo's xen is just a src tarball made from the mercurial repro, w/o
any patches (AFAIK).

cheers

Ming-Wei Shih
