Return-Path: <linux-kernel-owner+w=401wt.eu-S1760610AbYHEI67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760610AbYHEI67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 04:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758954AbYHEI6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 04:58:51 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:19806 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758601AbYHEI6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 04:58:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rKxFQuPf/oJAQQY9yl8PNKNEGV0cx1+y15DJxzRl6/PBPJoZqRSjky+I0dpfHFxSFV
         Tna3s73W7eGgK/Y4iBxFOxpoKGiYcgC+4pYoXK6TeHksosXKiQzD9YYe+m3vnpBO75iK
         399Sas3FVo2GJQTUAZu81kBy1DByZFbkrIluk=
Message-ID: <ef1cd66f0808050152g1dd8b96cl2df820607d480f0f@mail.gmail.com>
Date: Tue, 5 Aug 2008 09:52:22 +0100
From: "=?ISO-8859-1?Q?Jochen_Vo=DF?=" <jochen.voss@googlemail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH 2/4] list.h: add list_cut_position()
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
In-Reply-To: <20080804231320.GG6447@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217890089-12100-1-git-send-email-lrodriguez@atheros.com>
	 <20080804160011.ec964f1f.randy.dunlap@oracle.com>
	 <20080804231320.GG6447@tesla>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/8/5 Luis R. Rodriguez <lrodriguez@atheros.com>:
> +static inline void __list_cut_position(struct list_head *list,
> +               struct list_head *head, struct list_head *entry)
> +{
> +       struct list_head *new_first =
> +               (entry->next != head) ? entry->next : head;

Isn't this just an over-complicated way of writing "new_first = entry->next"?

> +       list->next = head->next;
> +       list->next->prev = list;
> +       list->prev = entry;
> +       entry->next = list;
> +       head->next = new_first;
> +       new_first->prev = head;
> +}
> +
> +/**
> + * list_cut_position - cut a list into two
> + * @list: a new list to add all removed entries
> + * @head: a list with entries
> + * @entry: an entry within head, could be the head itself
> + *     and if so we won't cut the list
> + */

I think it would be helpful if the comment explained what the function
actually does, i.e. that it moves the inital part of 'head' (up to and
including 'entry' from 'head' to 'list'.

> +static inline void list_cut_position(struct list_head *list,
> +               struct list_head *head, struct list_head *entry)
> +{
> +       BUG_ON(list_empty(head));
> +       if (list_is_singular(head))
> +               BUG_ON(head->next != entry && head != entry);

No other list function in "list.h" has BUG_ONs.  Why this one?

> +       if (entry == head)
> +               INIT_LIST_HEAD(list);

If there was data in 'list' before the call, it will be lost now.  Is
this intended behaviour?

> +       else
> +               __list_cut_position(list, head, entry);
> +}
> +

I hope this helps,
Jochen
-- 
http://seehuhn.de/
