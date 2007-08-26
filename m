Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbXHZP6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbXHZP6h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 11:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbXHZP6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 11:58:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:38200 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbXHZP6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 11:58:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ylraus2KUQBD1rUlhmWuwmAMrbPrj0ZePw9JtK0XH94KBlE7yeTVlxMP+XE8py/KuCwmxm0h/GqN4glgig7oIMJI232TlSuJdJze/2iGdhqHrfK2blmYiKUXqO/aiCfme02r8HvWBOPqQcJckf2kHze3qO4FeZq4ST6GA67qFy8=
Message-ID: <4877c76c0708260858i51ddfd6csb69d3adf405245eb@mail.gmail.com>
Date: Sun, 26 Aug 2007 08:58:06 -0700
From: "Michael Evans" <mjevans1983@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [patch v2 1/1] md: Software Raid autodetect dev list not array
Cc: "Michael J. Evans" <mjevans1983@comcast.net>, "Neil Brown" <neilb@suse.de>,
       "Ingo Molnar" <mingo@redhat.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708261453450.15614@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708222058.45480.mjevans1983@comcast.net>
	 <18126.21113.981032.286298@notabene.brown>
	 <200708260451.24868.mjevans1983@comcast.net>
	 <Pine.LNX.4.64.0708261453450.15614@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/26/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Aug 26 2007 04:51, Michael J. Evans wrote:
> > {
> >-      if (dev_cnt >= 0 && dev_cnt < 127)
> >-              detected_devices[dev_cnt++] = dev;
> >+      struct detected_devices_node *node_detected_dev;
> >+      node_detected_dev = kzalloc(sizeof(*node_detected_dev), GFP_KERNEL);\
>
> What's the \ good for, besides escaping the newline
> that is ignored as whitespace anyway? :-)
>

I hadn't even noticed that, I suppose I mashed the key above enter at
some time.  Removing from my local file.

> >@@ -5772,3 +5790,8 @@ static void autostart_arrays(int part)
> >-      for (i = 0; i < dev_cnt; i++) {
> >-              dev_t dev = detected_devices[i];
> >-
> >+              /* FIXME: max 'int' #DEFINEd somewhere?  not   0x7FFFFFFF ? */
> >+      while (!list_empty(&all_detected_devices) && i_scanned < 0x7FFFFFFF) {
>
> I doubt someone really has _that_ many devices. Of course, to be on the
> safer side, make it an unsigned int. That way, people could put in about
> 0xFFFFFFFE devs (which is even less likely than 0x7FFFFFFF)
>

There is that, but I'm almost expecting someone to ask me to remove
both the ints and kprint statement.  (I'd like them as part of some
kind of verbose startup that people would actually think to use
however.)  Additionally a though occurred to me earlier, if there are
That many devices, the chance of a UUID namespace collision might
actually be realistic anyway.  Though I'm not short sighted enough to
put it past anyone to have more then 32/64K possible block devices.
Anyone with that much cash today is probably buying hardware raid, but
who knows.

> >+              i_scanned++;
> >+              node_detected_dev = list_entry(all_detected_devices.next,
> >+                                      struct detected_devices_node, list);
> >+              list_del(&node_detected_dev->list);
> >+              dev = node_detected_dev->dev;
> >+              kfree(node_detected_dev);
>
>         Jan
> --
>
