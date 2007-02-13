Return-Path: <linux-kernel-owner+w=401wt.eu-S1751287AbXBMLhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbXBMLhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 06:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbXBMLhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 06:37:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbXBMLg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 06:36:59 -0500
Date: Tue, 13 Feb 2007 06:35:52 -0500
From: Jakub Jelinek <jakub@redhat.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Marcel Siegert <mws@linuxtv.org>, Arjan van de Ven <arjan@infradead.org>,
       mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org
Subject: Re: dvb shared datastructure bug?
Message-ID: <20070213113552.GL22959@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <1171352878.12771.30.camel@laptopd505.fenrus.org> <200702131204.47314.mws@linuxtv.org> <1a297b360702130314i3b67a828v804ddb85dc975101@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a297b360702130314i3b67a828v804ddb85dc975101@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 03:14:23PM +0400, Manu Abraham wrote:
> >thanks for pointing out this issue.
> >
> >attached find a patch that fixes the problem.
> >
> >@mauro - please pull changeset a7ac92d208fe
> >   dvbdev: fix illegal re-usage of fileoperations struct
> >
> >from  http://www.linuxtv.org/hg/~mws/v4l-dvb-fixtree
> >
> 
> Ack'd-by: Manu Abraham <manu@linuxtv.org>

Wouldn't it be better to kmalloc both struct dvb_device and
struct file_operations together instead of doing 2 separate allocations?
struct dvd_device_plus_fops
{
  struct dvb_device dev;
  struct file_operations fops;
} *dev_fops = kmalloc (sizeof (struct dvd_device_plus_fops), GFP_KERNEL);
*pdvbdev = dvbdev = (struct dvb_device *)dev_fops;
if (dev_fops == NULL)
  error handling;
memset (&dev_fops->fops, 0, sizeof (dev_fops->fops));
...
dvbdev->fops = &dev_fops->fops;

	Jakub
