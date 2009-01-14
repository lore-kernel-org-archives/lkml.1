Return-Path: <linux-kernel-owner+w=401wt.eu-S1759630AbZANGHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630AbZANGHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 01:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754789AbZANGH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 01:07:28 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:56490 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741AbZANGH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 01:07:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=LSgV6a40MX5R4/54DyABr7oMrQY/4PIQMhbIyBXwUPfi+rGMT3vpkv2quaNc0WMtX2
         KzVyVgfEsn6greb2PEndjU2X0U+zeIfc0g3+IrwucZV7hoGWQ+YpxQaLZXphZa42+Y7n
         yZQtYYErHMc4hHcoSS73t+96aGMaPxHGkRVOQ=
Message-ID: <86802c440901132207l433227d9nf149506012a5721e@mail.gmail.com>
Date: Tue, 13 Jan 2009 22:07:26 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "James Kirin" <james.kirin40@gmail.com>
Subject: Re: memory beyond4GB invisible to the system even though CONFIG_HIGHMEM64G=y
Cc: "Roland Dreier" <rdreier@cisco.com>, linux-kernel@vger.kernel.org
In-Reply-To: <baeb34bc0901131910n55cae670qc9d02c9f78c6432@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <baeb34bc0901131746n33cd536co331e32361df2fb72@mail.gmail.com>
	 <adaeiz6k4o4.fsf@cisco.com>
	 <baeb34bc0901131910n55cae670qc9d02c9f78c6432@mail.gmail.com>
X-Google-Sender-Auth: a3e92477756868ae
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 7:10 PM, James Kirin <james.kirin40@gmail.com> wrote:
> Thank you for your reply, Roland. Unfortunately, this continues
> happening after having installed the most recent version of the BIOS
> available from Dell.
>
> I understand this is a problem in the BIOS and not the kernel, but is
> there a way to have the kernel work around this bug in the BIOS and
> make that memory accessible? Eg,
>
> http://www.gossamer-threads.com/lists/linux/kernel/991748#991748

please do
1. boot linux with "disable_mtrr_trim" in grub.conf etc
2. after booting input:
echo "base=0x100000000 size=0x20000000 type=write-back" >/proc/mtrr

later you could put that line in one scripts and call it from inittab
# grep mtrrfixup /etc/inittab
mtrr:345:once:/root/mtrrfixup.sh

YH
