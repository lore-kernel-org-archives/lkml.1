Return-Path: <linux-kernel-owner+w=401wt.eu-S1752312AbYJaNqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbYJaNqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 09:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbYJaNp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 09:45:57 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:28367 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbYJaNp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 09:45:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lxYaQo7BlOmpb+UNrkfoMaTBXCxcc/lYspTAoGAwfphkdIp7T1ZFirc7lz8QKjbS7l
         ovgpzMD0AH7Y/nSTWOYxbf0+XVzUV44MG+e2eIMSbs6oNkD21/VMR9pIVu6iNrV3zzYL
         CZES9X4tWEXYaNP1Hfy/pUxCq/9QsHH7Hop8A=
Message-ID: <36ca99e90810310645i23fb93ddmdbe93f65905a2f80@mail.gmail.com>
Date: Fri, 31 Oct 2008 14:45:55 +0100
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] B+Tree library
Cc: "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1225458974.5546.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081026124643.GA1328@logfs.org>
	 <1225458974.5546.6.camel@johannes.berg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 14:16, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>> +static inline size_t btree_visitorl(struct btree_headl *head, long opaque,
>> +             visitorl_t func2)
>> +{
>> +     return btree_visitor(&head->h, &btree_geo32, opaque, visitorl, func2);
>> +}
>
> Incidentally, do you think it would be possible to implement a kind of
>
> btree_for_each_entry(e, ...) {
>        do something with e
> }

#define btree_for_each_entryl(__elem, __head, __opaque, ...)            \
({                                                                      \
    void f2(void *__elem, long opaque, unsigned long key, size_t index) \
    {                                                                   \
        (__VA_ARGS__);                                                  \
    }                                                                   \
    btree_visitorl(__head, __opaque, f2);                               \
});

usage:

btree_for_each_entryl(e, head, opaque, {
    do something with e
})

looks strange but works.

Bert

>
> macro or function/macro combination? You seem to be doing a recursive
> walk across the tree, would it be useful to have a linked list at the
> lowest level of nodes to be able to iterate more easily?
>
> johannes
>
