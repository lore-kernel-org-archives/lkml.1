Return-Path: <linux-kernel-owner+w=401wt.eu-S1751952AbXAVVz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbXAVVz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 16:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbXAVVz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 16:55:26 -0500
Received: from outbound-mail-43.bluehost.com ([69.89.18.12]:37992 "HELO
	outbound-mail-43.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751952AbXAVVzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 16:55:25 -0500
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Olivier Galibert <galibert@pobox.com>
Subject: Re: [PATCH] update MMConfig patches w/915 support
Date: Mon, 22 Jan 2007 13:55:33 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
References: <200701071142.09428.jbarnes@virtuousgeek.org> <200701081327.16019.jbarnes@virtuousgeek.org> <20070116192800.GB4192@dspnet.fr.eu.org>
In-Reply-To: <20070116192800.GB4192@dspnet.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701221355.34810.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.73.10 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 16, 2007 11:28 am, Olivier Galibert wrote:
> > But won't the bridge register value control what actually gets
> > decoded? If so, it sounds like this BIOS is buggy wrt mmconfig
> > mapping in general; good thing I'm not using any PCIe devices I
> > guess...
>
> Yeah.  I've checked the docs, I think I know what's going on.  On one
> hand, if the chipset is configured to have the range somewhere, it is
> decoded before anything external to the chipset, be it ram or mmaped
> i/o.  So the information you get from the chipset should not be able
> to conflict with anything by definition, it's the anything that
> wouldn't be visible.
>
> But in your case of a f0000000-ffffffff mapping, something else
> interesting is going on: it's conflicting with other internal
> registers of the chipset, which, being fixed address, probably have
> priority.  So you probably have to either reduce the range so that
> the chipset registers aren't touched, or drop mmconfig if the address
> is f0000000.
>
> Technically, we can have the exact same problem with the other
> chipsets.  BIOSen suck.

Ouch.  It doesn't seem like there's a sane general way to fix this up, 
aside from some sort of blacklist.  Maybe it's best to leave this 
particular bridge unsupported for now...

Thanks,
Jesse
