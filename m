Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbZBYAJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbZBYAJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 19:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZBYAJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 19:09:35 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:60515 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbZBYAJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 19:09:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=F4jECEh2+qqMNYdwdU/iTbN6HWYTP5uSHT+49HcLviZfMIFf5NBKDXwVONpWI3TqWy
         hzm9g/bhc2QikePOYHpIJQAQl7aoQhBzW2YLpMEtzvy0wIPu95yNzlTv0KdylcMIZffm
         lK8q1B2cmwUCmZcAufWAH8teB25y6BPthzyVU=
Message-ID: <49A48C38.20209@gmail.com>
Date: Tue, 24 Feb 2009 18:09:28 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Mike Mason <mmlnx@us.ibm.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Disabling an interrupt in interrupt context
References: <49A33B3C.6000907@us.ibm.com>
In-Reply-To: <49A33B3C.6000907@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Mason wrote:
> I have a need to disable an LSI interrupt from within the context of the 
> handler for that interrupt.  It appears that disable_irq_nosync() will 
> do the trick.  Besides dropping interrupts, which I don't care about 
> because the device is in an error state, what are the potential side 
> effects of doing this?  As far as I can tell, this will not prevent the 
> current in-flight handlers for that interrupt from finishing.

Well, if any other devices are sharing that IRQ line, they likely won't 
like it, for one thing.. How long are you planning on disabling the IRQ 
line for?
