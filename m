Return-Path: <linux-kernel-owner+w=401wt.eu-S1756737AbZFXIya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbZFXIya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 04:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756477AbZFXIyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 04:54:21 -0400
Received: from smtp103.sbc.mail.gq1.yahoo.com ([67.195.15.62]:42736 "HELO
	smtp103.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756701AbZFXIyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 04:54:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=g6nrR3JTB6USb3xI7qua0397R7UpCv7/FVliPtOH76ULsSLlM97BpbasWjkZbjt5P6I17u44VnXwAqyhUM285oiQ18CxDS+ygdY/jTzWiSNOZrZiRtB012mz/LkcF0yfeqMboYf/WSnAooybHh/YUcSfPeuvQVmSHgcA2Ovk0ko=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: A6DA6eEVM1lciyON8D.6SiHdz4aOQ3VxCXr9G0MrWTeghvTCjUUim517kf2auDvJx737bN8aPONXGeVfK9wK889wkkxl2nx5tnL5ZgC9jhlyjtGd0CpF7.Y4e0yxWSPk8hBk.lBykWwzXWmSK4XatVZX8NbfKRg1375R.NDGqb2lrzBKpvdNUPuNL9zgvr3qBxxUbVDDovCGL8pDaTOuHIAXjMEcGzDgffyXyJx2IhhE6OAlboZpW5sAukdfN5Ho4BaO6pWNs9We8sTK
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: PROBLEM: kernel oops with g_serial USB gadget on 2.6.30
Date: Wed, 24 Jun 2009 01:54:20 -0700
User-Agent: KMail/1.9.10
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
       "'Alan Stern'" <stern@rowland.harvard.edu>,
       "'Peter Korsgaard'" <jacmet@sunsite.dk>,
       "'USB list'" <linux-usb@vger.kernel.org>,
       "'Kernel development list'" <linux-kernel@vger.kernel.org>,
       kyungmin.park@samsung.com
References: <001201c9f341$20b8b710$622a2530$%szyprowski@samsung.com> <002101c9f49a$6cfcaf50$46f60df0$%szyprowski@samsung.com> <20090624094240.4097db11@lxorguk.ukuu.org.uk>
In-Reply-To: <20090624094240.4097db11@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906240154.21349.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009, Alan Cox wrote:
> Looks to me like the gs_write_room function takes a lock already held
> when the driver calls tty_flip_buffer_push() - which will and can call
> back into the driver (eg for echo processing)

That doesn't seem to explain whatever null pointer was being
traversed though.

A lock-already-held problem would self-deadlock, not oops.

