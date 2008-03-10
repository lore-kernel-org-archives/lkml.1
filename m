Return-Path: <linux-kernel-owner+w=401wt.eu-S1752528AbYCJKcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbYCJKcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 06:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbYCJKb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 06:31:58 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:56650 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbYCJKb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 06:31:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=XsyH2JdslT0Wp4iBAo43NeSuhtaFwhbk/rUc+TzpET82UX/JOjAaLG1IgMOteo6vz2CFFSvy0Yww7cgnpI1XIIERQkVkmmHhKuZgMQm6Yc0EOV7wKt13VCKY6AR0EY769jeK+qL5B18pKKBKX0VkiBtyJSV4Wxh/UvVG6Ctqvpc=
Message-ID: <da8150af0803100331l23aa0ac3lcd7f184156a20a56@mail.gmail.com>
Date: Mon, 10 Mar 2008 11:31:56 +0100
From: "Pierre Falda" <darkstuff@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: dev_queue_xmit question
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I apologize whether this question has been asked already, however I
performed a check on the archives and didn't find anything suitable to
my case.

I would like some enlightenment about dev_queue_xmit use:

The man page explains that the buffer is being 'consumed', however I
can increase the reference count value in order to attempt a resend.

Does this mean that I should proceed this way (see code below) in case
I am willing to send the same skb more than once (ie, multiple times)?



***********************************************************************
...
...

while(i want to send this skb)
{

       skb_get(skb)

       skb->dev = output_device;

       skb->packet_type = PACKET_OUTGOING;

        xmit_rvalue = dev_queue_xmit(skb)

        if(xmit_rvalue) /* != 0 not successful send */

                goto error;

}

       return (0);

error:

     dev_kfree_skb(skb);

     return (-1);

***********************************************************************

So, is it okay or this piece of code and technique should be used only
in case of skb transmission error?

In short, what I would like to obtain is avoiding a (p)skb_copy
overhead before the dev_queue_xmit call.

Thank you in advance :)

Pierre
