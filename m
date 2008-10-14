Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbYJNWj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbYJNWj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 18:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYJNWjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 18:39:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:6018 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbYJNWjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 18:39:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=f8v3GFK/k0TCUk21P+S+LchU3+LNePevcDXoJQ5XiBV5KjmCkv/Gdv0NiREB8UXhd4
         TyFzWWS6fiA1uWXguY1IY52K+76yYPAZuVC5TzzWUjqMulVgi8d6mfUOrRlaWphCWJcU
         WLR1hmQHu5CvVpV8i2nic7kwXVT+ZkTI+RqpA=
Message-ID: <86802c440810141539x97ceaa4meaab109fae3d9d4c@mail.gmail.com>
Date: Tue, 14 Oct 2008 15:39:44 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: donald.d.dugger@intel.com
Subject: Re: [PATCH] Enable console on PCI serial devices
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com>
X-Google-Sender-Auth: 5b3f15db753ebc8d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 3:31 PM,  <donald.d.dugger@intel.com> wrote:
> The problem with using a PCI serial card for the console is that, until
> the PCI serial driver is loaded, output will be lost.  The issue is that
> PCI serial devices use a non-standard I/O port address and sometimes use
> a non-standard crystal frequency.  This patch gets around those problems
> by allowing you to specify both I/O port address and crystal frequency on
> the kernel command line.  The serial console specification is enhanced to be:
>
>        BBBBPNF-III/CCC
>
> where BBBB is the baud rate, P is the parity, N is the number of bits,
> F is the flow control, III is the I/O port address (prefix with 0x for
> hexadecimal) and CCC is the crystal frequency.  -III and /CCC are optional
> and can be omitted although -III must be specified if you want to set
> /CCC.  For example, the option I use is:
>
>        console=ttyS0,115200-0xe880/921600

Did you check

console=uart8250,io,0xe880,115200n8

hope you can expand that to support CCC

YH
