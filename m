Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbXIXHLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbXIXHLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 03:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbXIXHK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 03:10:59 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:48881 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbXIXHK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 03:10:59 -0400
Subject: Re: [-mm Patch] net/bluetooth/hidp/core.c: Make hidp_setup_input()
	return int
From: Marcel Holtmann <marcel@holtmann.org>
To: roel <12o3l@tiscali.nl>
Cc: WANG Cong <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, maxk@qualcomm.com
In-Reply-To: <46F6E502.9000101@tiscali.nl>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	 <20070923030105.GH2475@hacking>  <46F6E502.9000101@tiscali.nl>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 09:09:11 +0200
Message-Id: <1190617751.5133.88.camel@aeonflux.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > This patch does the following things:
> > 
> > - Make hidp_setup_input() return int to indicate errors.
> > - Check its return value to handle errors.
> > 
> > Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> > 
> > ---
> >  net/bluetooth/hidp/core.c |    7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > Index: linux-2.6.23-rc6-mm1/net/bluetooth/hidp/core.c
> > ===================================================================
> > --- linux-2.6.23-rc6-mm1.orig/net/bluetooth/hidp/core.c
> > +++ linux-2.6.23-rc6-mm1/net/bluetooth/hidp/core.c
> > @@ -625,7 +625,7 @@ static struct device *hidp_get_device(st
> >  	return conn ? &conn->dev : NULL;
> >  }
> >  
> > -static inline void hidp_setup_input(struct hidp_session *session, struct hidp_connadd_req *req)
> > +static inline int hidp_setup_input(struct hidp_session *session, struct hidp_connadd_req *req)
> >  {
> >  	struct input_dev *input = session->input;
> >  	int i;
> > @@ -669,7 +669,7 @@ static inline void hidp_setup_input(stru
> >  
> >  	input->event = hidp_input_event;
> >  
> > -	input_register_device(input);
> > +	return input_register_device(input);
> >  }
> >  
> >  static int hidp_open(struct hid_device *hid)
> > @@ -823,7 +823,8 @@ int hidp_add_connection(struct hidp_conn
> >  	session->idle_to = req->idle_to;
> >  
> >  	if (session->input)
> > -		hidp_setup_input(session, req);
> > +		if ((err = (hidp_setup_input(session, req))))
> > +			goto failed;
> 
> This is confusing, why not just do
> 
> 	if (session->input) {
> 		err = hidp_setup_input(session, req);
> 		if (err)
> 			goto failed;
> 	}

lets use "if (err < 0)" and I am okay with that patch.

Regards

Marcel


