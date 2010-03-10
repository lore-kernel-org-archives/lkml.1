Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab0CJUvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 15:51:05 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:47636 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757119Ab0CJUvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 15:51:00 -0500
X-Sasl-enc: xxGUw3toc6mqj7ywuvllL95B03+rxE5GwaJcQEyLkqs7 1268254260
Date: Wed, 10 Mar 2010 17:50:57 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Karel Zak <kzak@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>,
       Mike Snitzer <snitzer@redhat.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: ATA 4 KiB sector issues.
Message-ID: <20100310205057.GD21704@khazad-dum.debian.net>
References: <4B947393.2050002@kernel.org>
 <yq1zl2ic058.fsf@sermon.lab.mkp.net>
 <170fa0d21003081134g491034e5v4aad4d43853e48ec@mail.gmail.com>
 <4B95F071.3070400@msgid.tls.msk.ru>
 <20100309100153.GD18077@nb.net.home>
 <4B961FE1.5040105@msgid.tls.msk.ru>
 <20100309121858.GA2020@nb.net.home>
 <yq1iq947oku.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1iq947oku.fsf@sermon.lab.mkp.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Mar 2010, Martin K. Petersen wrote:
> >>>>> "Karel" == Karel Zak <kzak@redhat.com> writes:
> 
> [Cleaned up the CC: list from hell]
> 
> Karel>  # cat /sys/block/md8/queue/{minimum,optimal}_io_size
> Karel>  65536 65536
> 
> This one had me puzzled.  We set min_io and opt_io correctly in raid5.c
> depending on number of non-parity disks.  And yet it turns into
> something nonsensical after.
> 
> Turns out we overrun unsigned int calculating the lowest common multiple
> in the stacking function.  That's why we ended up with the wrong value.
> 
> I never noticed this because my userland topology regression test tool
> uses unsigned long.
> 
> I'll get a patch off to Jens right away.

And please get the whole fixed deal in -stable eventually, for 2.6.32.y's
benefit :-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
