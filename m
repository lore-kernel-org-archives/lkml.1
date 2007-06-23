Return-Path: <linux-kernel-owner+w=401wt.eu-S1751909AbXFWDsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbXFWDsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 23:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbXFWDsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 23:48:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:28975 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbXFWDsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 23:48:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=CK3LikcLSH3ht5/2dATG33dTPdi+/ob8TbE8JSBburGUW0jmEQIviHZf/SPRfMGQ1TmRC7+rooWqa9dLJXmyEabKgZM2RGOmFUrTmUnnYQgycGJDJ8xERtt9C0wj4bw1B2GmaaF/wXuSvgPnBLrdoCfjdoLvPp65qASGhhK3h/I=
Message-ID: <661de9470706222048g638a06dboc0b2e85975a9ba70@mail.gmail.com>
Date: Sat, 23 Jun 2007 09:18:07 +0530
From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
To: "Paul Menage" <menage@google.com>
Subject: Re: [patch -rss] Make RSS accounting display more user friendly
Cc: "Pavel Emelianov" <xemul@openvz.org>, "Andrew Morton" <akpm@osdl.org>,
       "Linux Containers" <containers@lists.osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <6599ad830706220839h2a556c76he11b78c2c4cdb86e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070620154655.13844.42876.sendpatchset@balbir-laptop>
	 <6599ad830706211217l65d76d4ehb42f9165bcf45dd@mail.gmail.com>
	 <467B2F4F.2030101@openvz.org>
	 <6599ad830706220839h2a556c76he11b78c2c4cdb86e@mail.gmail.com>
X-Google-Sender-Auth: 36773e6bdbdaf518
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/22/07, Paul Menage <menage@google.com> wrote:
> On 6/21/07, Pavel Emelianov <xemul@openvz.org> wrote:
> >
> > Nothing wrong, but currently they are shown in "natural" points, i.e. in
> > those that the controller accounts them in. For RSS controller the natural
> > point is "page", but auto-converting them from pages to bytes is wrong, as
> > not all the controllers account in pages.
>
> This exposes more implementation detail than I think is good.
> Something like a memory controller should use a more abstract
> interface like bytes, and do the conversion to/from its internal
> "natural" units like pages internally. E.g. the example cpu accounting
> controller that I included with my patch set reports usage in
> milliseconds, even though it counts internally in jiffies.
>
Hi, Paul,

Bytes are too fine grained. Do we also accept the input in bytes? kB
are probably the best, but then with the limit set to LONG_MAX, kB
wrap around (if the input is in units of pages) on 64 bit machines
(the sameapplies to bytes as well).

The problem with input in bytes is that the user will have to ensure
that the input is
a  multiple of page size, which implies that she would need to use the
calculator every time.
