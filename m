Return-Path: <linux-kernel-owner+w=401wt.eu-S1751259AbXBMMC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbXBMMC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 07:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbXBMMC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 07:02:56 -0500
Received: from nijmegen.renzel.net ([195.243.213.130]:37397 "EHLO
	nijmegen.renzel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbXBMMCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 07:02:55 -0500
From: Marcel Siegert <mws@linuxtv.org>
To: Jakub Jelinek <jakub@redhat.com>
Subject: Re: dvb shared datastructure bug?
Date: Tue, 13 Feb 2007 13:02:46 +0100
User-Agent: KMail/1.9.6
Cc: Manu Abraham <abraham.manu@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, mchehab@infradead.org,
       v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
References: <1171352878.12771.30.camel@laptopd505.fenrus.org> <1a297b360702130314i3b67a828v804ddb85dc975101@mail.gmail.com> <20070213113552.GL22959@devserv.devel.redhat.com>
In-Reply-To: <20070213113552.GL22959@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702131302.47344.mws@linuxtv.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 February 2007, Jakub Jelinek wrote:
> On Tue, Feb 13, 2007 at 03:14:23PM +0400, Manu Abraham wrote:
> > >thanks for pointing out this issue.
> > >
> > >attached find a patch that fixes the problem.
> > >
> > >@mauro - please pull changeset a7ac92d208fe
> > >   dvbdev: fix illegal re-usage of fileoperations struct
> > >
> > >from  http://www.linuxtv.org/hg/~mws/v4l-dvb-fixtree
> > >
> > 
> > Ack'd-by: Manu Abraham <manu@linuxtv.org>
> 
> Wouldn't it be better to kmalloc both struct dvb_device and
> struct file_operations together instead of doing 2 separate allocations?
> struct dvd_device_plus_fops
> {
>   struct dvb_device dev;
>   struct file_operations fops;
> } *dev_fops = kmalloc (sizeof (struct dvd_device_plus_fops), GFP_KERNEL);
> *pdvbdev = dvbdev = (struct dvb_device *)dev_fops;
> if (dev_fops == NULL)
>   error handling;
> memset (&dev_fops->fops, 0, sizeof (dev_fops->fops));
> ...
> dvbdev->fops = &dev_fops->fops;
> 
> 	Jakub
> 

hi jakub, 

it may be worth doing that, but, imho that can be done when we are perfoming
some revise of the whole dvb-core subsystem. 

at the moment i would stay at "as-is", the code is more readable and the more "cost"
of the additional alloc is affordable.

thanks for your comments.
marcel



