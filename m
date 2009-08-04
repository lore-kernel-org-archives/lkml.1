Return-Path: <linux-kernel-owner+w=401wt.eu-S933868AbZHEA2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868AbZHEA2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 20:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933846AbZHEA2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 20:28:46 -0400
Received: from n26.bullet.mail.mud.yahoo.com ([68.142.206.221]:26484 "HELO
	n26.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933383AbZHEA2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 20:28:30 -0400
X-Yahoo-Newman-Id: 152481.90920.bm@omp416.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xTM6nIo9nrp2Sr4z9lrDV5DoiXYR83XHfFWW3ug+6faxE6xCGNLckzJKuIResABbbaMPwpX8tJgHsbls93UnDAHOA+GYXgiEkzOEOSTv+JQ4Qq4a6kneQzGvYan1fJjgfZXY39Lwqwuy3Nk5dzL8DgGEwgxRfQ20pjm6DospOv0=  ;
X-YMail-OSG: pFXrxGUVM1k4gu0OI1UgGoRd_fZR8Dh_S5oboieGDGVQkcEYJ5cBE0QXyCljg7pdRaUMCWi56YVWhh1rwoT7x_ThJ3Riucp1MAYdXpFpzbr6PUb2he8S7WYC1nktP6PJagFTXrF40KHh1kGybyIm9pm6dXNdqsY9eHu9KcBZx41eIRbiHoiej4EW08pUSI4jhbXbADNUnSPZecz2PaoVZfKoPPuk.5WfGI5UA0vBi377yawaNDd_ZUUYgHRB0wNZ.PiiYN2SPQiEEyOk.2x5CO3.wzwA2tvg4D0Rkq2tKIEETS_EYOc-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH 1/7] spi: Add support for device table matching
Date: Mon, 3 Aug 2009 19:21:22 -0700
User-Agent: KMail/1.9.10
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
References: <20090729170345.GA26787@oksana.dev.rtsoft.ru> <20090729170457.GA4803@oksana.dev.rtsoft.ru> <20090729214446.GB1728@fluff.org.uk>
In-Reply-To: <20090729214446.GB1728@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200908031921.23126.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 July 2009, Ben Dooks wrote:
> >  struct spi_driver {
> > +     const struct spi_device_id *id_table;
> > +     int                     (*probe_id)(struct spi_device *spi,
> > +                                         const struct spi_device_id *id);
> 
> how about leaving it at just probe and have either a call or a field
> in the device that you can look at to see if this was a new style of
> call?
> 
> >       int                     (*probe)(struct spi_device *spi);

For the record, if this is going to happen I think the
appropriate long-term solution is to have probe() take
the device_id just as it does with other busses.

Of course that involves changing *every* SPI driver...
and I'd rather not do that quite yet.




