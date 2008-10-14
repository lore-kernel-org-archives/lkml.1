Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbYJNBe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbYJNBe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 21:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbYJNBeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 21:34:18 -0400
Received: from smtp-out.google.com ([216.239.33.17]:25209 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbYJNBeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 21:34:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=VsyIgdlGeNEMKRNfySuCJ/vND0bnaSwryIOef5Sy9/ABWpOBWQE+zKN0mLsaXP/VP
	tLnGZ+IYIX/6a3OKlNYtA==
Message-ID: <da824cf30810131833g6e509d0dvb6cce6c7220a1a28@mail.gmail.com>
Date: Mon, 13 Oct 2008 18:33:55 -0700
From: "Grant Grundler" <grundler@google.com>
To: "kenneth johansson" <ken@kenjo.org>
Subject: Re: weird throughput on write to SATA disk
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1223936351.3947.41.camel@duo>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223925629.3947.7.camel@duo>
	 <da824cf30810131407m1a73bd11xa30fd118ee5a4c8f@mail.gmail.com>
	 <1223932956.3947.22.camel@duo>
	 <da824cf30810131434r34179666kc8d075c7eecdbbae@mail.gmail.com>
	 <1223936351.3947.41.camel@duo>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 3:19 PM, kenneth johansson <ken@kenjo.org> wrote:
...
>> Can you try "dd oflag=direct if=/dev/null of=/dev/sdb bs=64k"?
>
> I changed to use O_DIRECT and it's much more consistent now. 69-75 with
> 74 about 95% of the time.

That's low but it could be worse. Many things can contribute to slow
disks. Favorites are overtemp (See SMART field 194) and vibration (no
measurement possible w/o special equipment). "dd" isn't exactly a
performance application until one uses really big block sizes (1MB or
larger). sgp_dd is better since it is multi-threaded. fio has all the
right knobs to test disk perf and measure it properly.

> the disk is supposed to have 105 115 sustained
> data rate.

Where did 105-115 number come from?

The best I've seen to date with 7200 rpm drives was 108MB/s on the
outside diameter. That degrades slowly until about 60-70% towards the
inside diameter and then drops off dramatically (down to something
like 50MB/s).

hth,
grant
