Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbYJMNoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbYJMNoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 09:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYJMNoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 09:44:30 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:19202 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbYJMNo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 09:44:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=dWktZQOx3enoxaa7pKKaOk5+OxtNKYdP/CccZTBVOxyv9+vORCc4EtCUDdPC0/9pPK
         KXX48p5pJDG+9L2au8QGsUiy6L57282+BUOmOZgdkpBODzSoQXez1ZL7kIBwuFFLK01/
         01qH+XD7+igVCOh2qMwd9GZI+mZzDQTziA8AI=
Message-ID: <84144f020810130644w7f89f3d9m3c3d3e63d3034534@mail.gmail.com>
Date: Mon, 13 Oct 2008 16:44:28 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: Distributed storage release.
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20081013133850.GA13565@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081006160034.GA611@2ka.mipt.ru>
	 <20081012192419.fd8394c9.akpm@linux-foundation.org>
	 <20081013133850.GA13565@2ka.mipt.ru>
X-Google-Sender-Auth: fb44b0bfc346f7a6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Evgeniy,

On Mon, Oct 13, 2008 at 4:38 PM, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
>> > +static void *dst_crypto_thread_init(void *data)
>> > +{
>> > +   struct dst_node *n = data;
>> > +   struct dst_crypto_engine *e;
>> > +   int err = -ENOMEM;
>> > +
>> > +   e = kzalloc(sizeof(struct dst_crypto_engine), GFP_KERNEL);
>> > +   if (!e)
>> > +           goto err_out_exit;
>> > +   e->src = kzalloc(sizeof(struct scatterlist) * 2 * n->max_pages,
>> > +                   GFP_KERNEL);
>>
>> kcalloc()?
>
> What's the difference? In saving one space and replacing another with
> comma? I do not particulary care, but would like to know why it is
> needed :)

kcalloc() will check for multiplication overflow which is nice
especially if size is passed from user-space (not sure if that applies
here).
