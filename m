Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbXLFVUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbXLFVUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 16:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbXLFVUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 16:20:46 -0500
Received: from nz-out-0506.google.com ([64.233.162.228]:52854 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbXLFVUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 16:20:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IjP+BGUdtW58CGVBoQ2ve8zsjdQ3LCZ6J6UAlJFx7uslLZIuqbVB4LvKYJ4bNG7Wc1yG2KyiOhF9XvauzV+F/x+R82a8CE0pkIMmEAO2ubS3OJDAXow6LlNTqLC4N8sh8odpBA5KcEYz9pA4lsXnAo4O5G+tXCLt9iUmscPw02c=
Message-ID: <5d6222a80712061320w1224fa10r1d15f214c7e45862@mail.gmail.com>
Date: Thu, 6 Dec 2007 19:20:43 -0200
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH 1/19] unify desc_struct
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com
In-Reply-To: <200712062154.40075.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1196957800568-git-send-email-gcosta@redhat.com>
	 <11969578092869-git-send-email-gcosta@redhat.com>
	 <200712062154.40075.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 6, 2007 6:54 PM, Andi Kleen <ak@suse.de> wrote:
>
> > +/*
> > + * FIXME: Acessing the desc_struct through its fields is more elegant,
> > + * and should be the one valid thing to do. However, a lot of open code
> > + * still touches the a and b acessors, and doing this allow us to do it
> > + * incrementally. We keep the signature as a struct, rather than an union,
> > + * so we can get rid of it transparently in the future -- glommer
> > + */
> > +#define raw_desc_struct struct { unsigned int a, b; }
> > +#define detailed_desc_struct                                   \
> > +  struct {                                                       \
> > +     u16 limit0;                                             \
> > +     u16 base0;                                              \
> > +     unsigned base1 : 8, type : 4, s : 1, dpl : 2, p : 1;    \
> > +     unsigned limit : 4, avl : 1, l : 1, d : 1, g : 1, base2 :8;\
> > +  }
>
> The standard clean way to do this is with a anonymous union.
It is an anonymous union.

However:

* It's an union of structs
* I wished to keep the toplevel type as a struct
The alternative would be to write:

struct desc_struct {
union {
    struct { unsigned int a, b; };
    struct {
               u16 limit0;
               u16 base0;
               unsigned base1 : 8, type : 4, s : 1, dpl : 2, p : 1;
               unsigned limit : 4, avl : 1, l : 1, d : 1, g : 1, base2 :8;
    };
};
};

Which is fine, it's all the same in the end. Just with more shift
rights, and more visual pollution.


-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
