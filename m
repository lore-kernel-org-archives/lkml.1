Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbYGHOCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbYGHOCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 10:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755968AbYGHOB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 10:01:57 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:10949 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbYGHOB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 10:01:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:x-face:content-type
         :content-transfer-encoding;
        b=dbRM/sD0YzNufcwLWvFNlxkV0r7/Pz+IpwFBJPZsUWcgS6TwikXSVZ6aXmWH2ZPjPB
         m5JiPua+cJ2+4kcaHPIenpNIQSnm6Pvv47xhk8dSuIsh50ZjX3lZ3ibj+tFlRQv+gxfu
         qc5ss8fITJDYVeCREU/rqUlISunnW97xR0iPA=
Message-ID: <4873734F.4030808@gmail.com>
Date: Tue, 08 Jul 2008 11:01:51 -0300
From: Daniel Ribeiro <drwyrm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.9) Gecko/20080204 Thunderbird/2.0.0.9 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Eric Miao <eric.y.miao@gmail.com>
CC: Stefan Schmidt <stefan@datenfreihafen.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, sameo@openedhand.com,
       linux-kernel@vger.kernel.org
Subject: Re: [Patch 06/10] mfd: PCAP driver for the Motorola EZX GSM mobile
 phones
References: <20080707184000.411913919@datenfreihafen.org> <20080707184129.554483476@datenfreihafen.org> <74d0deb30807071221u4e216f76l479766925c903b5f@mail.gmail.com> <20080707200251.GA3449@datenfreihafen.org> <48730DE2.2050302@gmail.com>
In-Reply-To: <48730DE2.2050302@gmail.com>
X-Enigmail-Version: 0.95.0
X-Face: "2k[SrH\xnkN5/pfz\>x7..hXSO/=wJP,kq_[n2zz2Z/*eX)+3P+7bHjF%nipg[9Fq:);I7o16&EW7Z4nmO9TkB2@v$;#./CXd,g0&z[@>*=jM>+$pP:SNqwwtoQ"9^5Z$Xev+KwSyxVXy>E~V=3$"L3'm/6pfFN]sKvY,'6oM7*)GtB>b-
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Miao escreveu:
> The irq2pcap[] array looks horrible to me. It's actually a sparse array.
> Isn't there a nice 1:1 mapping using a formular??
> 
> Besides, the IRQ numbering scheme has now changed to a more generic way,
> I suggest to pull from Russell's latest git tree and rebase the IRQ
> part.

	Will do as you suggested and get rid of the arrays.

> The following block of code:
> 
> +	if (pcap_data->cs >= 0) {
> +		if (machine_is_ezx_a780() || machine_is_ezx_e680())
> +			gpio_direction_output(pcap_data->cs, 1);
> +		else
> +			gpio_direction_output(pcap_data->cs, 0);
> +	}
> 
> has 3 occurrences in the driver (2 in ezx_ssp_pcap_putget, 1 in ezx_pcap_probe)
> which is good reason to fold this into the platform data.
> 
> Well, if the above is done in platform data, I guess you won't mind another bit
> flag (e.g. PCAP_REDIRECT_IRQ or something alike) added in platform data, either

	Moved to platform data. What should PCAP_REDIRECT_IRQ flag do?

-- 
Daniel Ribeiro
