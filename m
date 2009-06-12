Return-Path: <linux-kernel-owner+w=401wt.eu-S1763258AbZFLQEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763258AbZFLQEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758100AbZFLQE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:04:27 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:51596 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbZFLQE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:04:26 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: tomaz.mertelj@guest.arnes.si
Subject: Re: [lm-sensors] [PATCH] hwmon: Add driver for VIA CPU core	temperature
Date: Fri, 12 Jun 2009 11:04:23 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>, Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
References: <20090612_152510_043383.tomaz.mertelj@guest.arnes.si> <200906121031.05738.lkml@morethan.org>
In-Reply-To: <200906121031.05738.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906121104.26174.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri June 12 2009, Michael S. Zick wrote:
> On Fri June 12 2009, tomaz.mertelj@guest.arnes.si wrote:
> > > 
> > > The author had a problem in that routine -
> > > try this one (32bit machines only) -
> > > 
> > > Mike 
> > 
> > DEBNAS:/home# for r in 0x1160 0x1161 0x1162 0x1163 0x1164 0x1165 0x1166 
> > 0x1167
> > 0x1168 0x1169 0x116a 0x116b 0x116c 0x1152 0x1153 ; do  ./rdmsrll $r ; 
> > done
> > MSR register 0x1160 => 08:04:83:94:bf:c2:39:c8
> > MSR register 0x1161 => 08:04:83:94:bf:ce:12:88
> > MSR register 0x1162 => 08:04:83:94:bf:d0:7a:a8
> > MSR register 0x1163 => 08:04:83:94:bf:9e:1f:88
> > MSR register 0x1164 => 08:04:83:94:bf:9c:ff:78
> > MSR register 0x1165 => 08:04:83:94:bf:87:6e:18
> > MSR register 0x1166 => 08:04:83:94:bf:a1:87:b8
> > MSR register 0x1167 => 08:04:83:94:bf:f1:cc:b8
> > MSR register 0x1168 => 08:04:83:94:bf:c6:22:08
> > MSR register 0x1169 => 08:04:83:94:bf:cf:b8:68
> > MSR register 0x116a => 08:04:83:94:bf:a3:57:d8
> > MSR register 0x116b => 08:04:83:94:bf:b3:a8:d8
> > MSR register 0x116c => 08:04:83:94:bf:ea:04:48
> > MSR register 0x1152 => 08:04:83:94:bf:84:85:e8
> > MSR register 0x1153 => 08:04:83:94:bf:d6:fb:18
> > 
> > I 
> > I hope this is better.
> >
> 
> The tool is broke - it is not reporting read failures.
> Evidently those register ranges are masked out somewhere; 
> will check on why/where.
>

The tool does not report read failures.
**BUT** if you remember to "modprobe msr" or have it built in...
Translation: Cockpit error.  ;)

root@cb01:~# for r in 0x1160 0x1161 0x1162 0x1163 0x1164 0x1165 0x1166 0x1167 0x1168 0x1169 0x116a 0x116b 0x116c 0x1152 0x1153 ; do ./rdmsrll  $r ; done
MSR register 0x1160 => 00:00:00:00:00:00:05:dc
MSR register 0x1161 => 00:00:00:00:00:00:03:e8
MSR register 0x1162 => 00:00:00:00:00:00:00:00
MSR register 0x1163 => 00:00:00:00:00:00:00:00
MSR register 0x1164 => 00:00:00:00:00:00:00:5f
MSR register 0x1165 => 00:00:00:00:00:00:00:64
MSR register 0x1166 => 00:00:00:00:00:00:00:7d
MSR register 0x1167 => 00:00:00:00:00:00:00:00
MSR register 0x1168 => 00:00:00:00:00:00:01:8d
MSR register 0x1169 => 00:00:00:00:00:00:00:32
MSR register 0x116a => 00:00:00:00:00:00:00:03
MSR register 0x116b => 00:00:00:00:00:00:01:a6
MSR register 0x116c => 00:00:00:00:00:00:03:34
MSR register 0x1152 => e7:2c:b3:9f:fb:ff:ff:ff
MSR register 0x1153 => 04:06:0c:09:fe:ff:ff:ff

Which is the same data as reported by msr-tools.

Mike 
> Mike 
> > Tomaz
> > 
> > 
> > 
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


