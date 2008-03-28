Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbYC1WgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbYC1WgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 18:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbYC1WgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 18:36:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:62796 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbYC1WgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 18:36:10 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 3/7] [NET]: uninline dev_alloc_skb, de-bloats a lot
Date: Fri, 28 Mar 2008 23:34:29 +0100
User-Agent: KMail/1.8.2
Cc: ilpo.jarvinen@helsinki.fi, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com
References: <1206621486-5408-3-git-send-email-ilpo.jarvinen@helsinki.fi> <200803280036.59311.vda.linux@googlemail.com> <20080327.175212.119805454.davem@davemloft.net>
In-Reply-To: <20080327.175212.119805454.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_1JX7HKxsXNWw1mp"
Message-Id: <200803282334.29975.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_1JX7HKxsXNWw1mp
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 28 March 2008 01:52, David Miller wrote:
> From: Denys Vlasenko <vda.linux@googlemail.com>
> Date: Fri, 28 Mar 2008 00:36:59 +0100
> 
> > Can you add a comment which explains the intent?
> > 
> > +struct sk_buff *dev_alloc_skb(unsigned int length)
> > +{
> > +       /* There is more code here than it seems:
> > +        * __dev_alloc_skb is an inline */
> > +	return __dev_alloc_skb(length, GFP_ATOMIC);
> > +}
> > +EXPORT_SYMBOL(dev_alloc_skb);
> 
> I've applied his patch already, if you want this comment
> please submit the patch to add it and also please use
> the correct formatting of the comment.

Here it is.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_1JX7HKxsXNWw1mp
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="dev_alloc_skb_comment.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dev_alloc_skb_comment.diff"

--- net-2.6.26/net/core/skbuff.c	Fri Mar 28 23:31:05 2008
+++ net-2.6.26.comment/net/core/skbuff.c	Fri Mar 28 23:33:03 2008
@@ -277,6 +277,10 @@
  */
 struct sk_buff *dev_alloc_skb(unsigned int length)
 {
+	/*
+	 * There is more code here than it seems:
+	 * __def_alloc_skb is an inline
+	 */
 	return __dev_alloc_skb(length, GFP_ATOMIC);
 }
 EXPORT_SYMBOL(dev_alloc_skb);

--Boundary-00=_1JX7HKxsXNWw1mp--
