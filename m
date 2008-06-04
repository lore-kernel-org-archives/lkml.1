Return-Path: <linux-kernel-owner+w=401wt.eu-S1758474AbYFDH1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474AbYFDH1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 03:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbYFDH1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 03:27:33 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44917 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbYFDH1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 03:27:32 -0400
Date: Wed, 4 Jun 2008 16:32:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       balbir@linux.vnet.ibm.com, menage@google.com, xemul@openvz.org
Subject: Re: [RFC][PATCH 1/2] memcg: res_counter hierarchy
Message-Id: <20080604163253.647199da.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080604072048.38CF85A0C@siro.lan>
References: <20080604140153.fec6cc99.kamezawa.hiroyu@jp.fujitsu.com>
	<20080604072048.38CF85A0C@siro.lan>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Jun 2008 16:20:48 +0900 (JST)
yamamoto@valinux.co.jp (YAMAMOTO Takashi) wrote:

> >  ssize_t res_counter_write(struct res_counter *counter, int member,
> > -		const char __user *buf, size_t nbytes, loff_t *pos,
> > -		int (*write_strategy)(char *buf, unsigned long long *val));
> > +	const char __user *buf, size_t nbytes, loff_t *pos,
> > +        int (*write_strategy)(char *buf, unsigned long long *val),
> > +	int (*set_strategy)(struct res_counter *res, unsigned long long val,
> > +			    int what),
> 
> this comma seems surplus.
> 
Ouch, I thought I fixed this...maybe patch reflesh trouble. Thanks.


> > +	);
> 
> > +int res_counter_return_resource(struct res_counter *child,
> > +				unsigned long long val,
> > +	int (*callback)(struct res_counter *res, unsigned long long val),
> > +	int retry)
> > +{
> 
> > +		callback(parent, val);
> 
> s/parent/child/
> 
Hmm..yes. 

Thanks,
-Kame

