Return-Path: <linux-kernel-owner+w=401wt.eu-S1757007AbYE0GU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007AbYE0GU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 02:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbYE0GUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 02:20:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:63721 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbYE0GUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 02:20:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BtCQRda+FRDoBMLQxkd0OmAzmESs8i4XX7W09KaSbI7Uv4uCgGjPJhwQztwYDekpTqXEYyflMB9OmPALZuGyMlRdsBjcMRUwV3hzE/LSXgUJBIgO/r+gygErck6zEW2o07NgXdlqYsFDsxhvJc0epS00bI1mGLl2Td8atb9yjrE=
Message-ID: <84144f020805262320k5740cd25lf16d7838d5358f0b@mail.gmail.com>
Date: Tue, 27 May 2008 09:20:06 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Patrick McHardy" <kaber@trash.net>
Subject: Re: possible double call of kfree_skb in net/llc/llc_sap.c
Cc: "Dmitry Petukhov" <dmgenp@gmail.com>, linux-kernel@vger.kernel.org,
       "Linux Netdev List" <netdev@vger.kernel.org>
In-Reply-To: <483BA72B.5010207@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <84ee89da0805262300v747c712ayfb60ac8aa790edb7@mail.gmail.com>
	 <483BA72B.5010207@trash.net>
X-Google-Sender-Auth: 8b2e92354c96ae11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Petukhov wrote:
>> In the file  net/llc/llc_sap.c, funcion llc_sap_state_process,
>> the call to kfree_skb in the line 227 can proceed even if skb was already
>> freed
>> on line 218, or  224, or queued to the user within sock_queue_rcv_skb
>> function.
>> Obviously return statement is missing after line 225.
>>
>> This problem was found by Alex Shevkov.

On Tue, May 27, 2008 at 9:16 AM, Patrick McHardy <kaber@trash.net> wrote:
> Could you send a patch please?

I wonder how the code got in that shape but it's probably best to just
remove the extra kfree_skb() calls and do it unconditionally at the
end of the function.
