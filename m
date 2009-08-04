Return-Path: <linux-kernel-owner+w=401wt.eu-S932744AbZHDVD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744AbZHDVD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 17:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932582AbZHDVD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 17:03:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53956 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932573AbZHDVD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 17:03:57 -0400
Date: Tue, 4 Aug 2009 22:03:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Daniel Ribeiro <drwyrm@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
       eric.y.miao@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       openezx-devel@lists.openezx.org,
       Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <20090804210342.GC29518@sirena.org.uk>
References: <1249291800-15316-1-git-send-email-drwyrm@gmail.com>
 <20090803172125.2A490526EA5@mailhub.coreip.homeip.net>
 <20090804225247.8a0bf6d4.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090804225247.8a0bf6d4.ospite@studenti.unina.it>
X-Cookie: Are you sure the back door is locked?
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] input: PCAP2 based touchscreen driver
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 10:52:47PM +0200, Antonio Ospite wrote:
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> > > +static int __devinit pcap_ts_probe(struct platform_device *pdev)
> > > +{
> > > +	struct input_dev *input_dev;
> > > +	struct pcap_ts *pcap_ts;
> > > +	int err = -ENOMEM;
> > > +
> > > +	pcap_ts = kzalloc(sizeof(*pcap_ts), GFP_KERNEL);
> > > +	if (!pcap_ts)
> > > +		return err;
> > > +
> > > +	pcap_ts->pcap = platform_get_drvdata(pdev);
> > > +	platform_set_drvdata(pdev, pcap_ts);

> > Ewww... Don't mess with data that does not belong to you. Also I don't
> > see where you restore it so after unloading the driver reload with
> > probably lead to "inetersting" results.

> Dmitry can you suggest a better way to make the pcap_ts pointer get to
> pcap_ts_remove()? We need it in order to remove the input device.
> Or keeping this hack, restoring the original value on remove, can be
> acceptable?

> We will have to fix this also in all other pcap subdrivers.

Two options from other MFDs:

 - Include the data for the input device in the main pcap data; this
   removes the need to faff around with the 
 - Always find the main pcap data by using dev_get_drvdata() on the
   parent device of the child, perhaps keeping a copy of a pointer to
   it in the local data for simplicity.
