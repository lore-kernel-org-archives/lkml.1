Return-Path: <linux-kernel-owner+w=401wt.eu-S936768AbZAPTH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936768AbZAPTH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 14:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbZAPTHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 14:07:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754106AbZAPTHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 14:07:42 -0500
Date: Fri, 16 Jan 2009 11:07:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] firs round of SCSI bug fixes for 2.6.29-rc1
Message-Id: <20090116110708.75c5828d.akpm@linux-foundation.org>
In-Reply-To: <1232131733.3224.46.camel@localhost.localdomain>
References: <1232117771.3224.21.camel@localhost.localdomain>
	<20090116090928.e43c986e.akpm@linux-foundation.org>
	<1232131733.3224.46.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009 13:48:53 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> > > +++ b/drivers/scsi/qla2xxx/qla_init.c
> > > @@ -1258,35 +1258,48 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
> > >  {
> > >  	int	rval;
> > >  	unsigned long flags = 0;
> > > -	int cnt;
> > > +	int cnt, que;
> > >  	struct qla_hw_data *ha = vha->hw;
> > > -	struct req_que *req = ha->req_q_map[0];
> > > -	struct rsp_que *rsp = ha->rsp_q_map[0];
> > > +	struct req_que *req;
> > > +	struct rsp_que *rsp;
> > > +	struct scsi_qla_host *vp;
> > >  	struct mid_init_cb_24xx *mid_init_cb =
> > >  	    (struct mid_init_cb_24xx *) ha->init_cb;
> > 
> > This cast worries me.  It's a cast between two complex data structures
> > which appear to have nothing to do with each other.
> 
> Actually, it's a C++ type construct.  ha->init_cb is of type init_cb_t,
> mid_init_cb actually contains this (via a second indirection) as the
> first element, so what it's doing is dynamically casting out based on
> the board type.

Ah, OK, I got lost amongst the typedefs and pointers.

This code could/should use container_of() for this operation?
