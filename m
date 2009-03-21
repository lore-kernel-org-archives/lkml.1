Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536AbZCUFqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbZCUFqj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 01:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbZCUFqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 01:46:24 -0400
Received: from mail-gx0-f208.google.com ([209.85.217.208]:53572 "EHLO
	mail-gx0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbZCUFqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 01:46:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=q1CLavjjaaVpHbRLbJ9TmWCtd2G0dA2nwEnHrw/fyoRwUnF/qOXnpET+NU23UDWFwT
         1eu2uY0+Vs4Iz124LxisVp/y0eDZrQks6d9g508QpZwYV697KLWSdT9B+lDX8hGXyh5k
         R08/3BF9yYjJPAqy+8JL88+OPg/029qWQ1M1c=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Question about usage of RCU in the input layer
Date: Fri, 20 Mar 2009 22:46:15 -0700
User-Agent: KMail/1.11.1 (Linux/2.6.27.19-170.2.35.fc10.x86_64; KDE/4.2.1; x86_64; ; )
Cc: paulmck@linux.vnet.ibm.com, dipankar@in.ibm.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090318215812.15496a86@infradead.org> <20090320020750.GA6807@linux.vnet.ibm.com> <20090319202032.4c971d92@infradead.org>
In-Reply-To: <20090319202032.4c971d92@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903202246.15772.dmitry.torokhov@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 March 2009 20:20:32 Arjan van de Ven wrote:
> > I don't claim to understand the code in question, so it is entirely
> > possible that the following is irrelevant.  But one other reason for
> > synchronize_rcu() is:
> >
> > 1.    Make change.
> >
> > 2.    synchronize_rcu()
> >
> > 3.    Now you are guaranteed that all CPUs/tasks/whatever
> > currently running either are not messing with you on the one hand, or
> >       have seen the change on the other.
>
> ok so this is for the case where someone is already iterating the list.
>
> I don't see anything in the code that assumes this..

This is something that input core guarantees to its users: by the time
input core calls hander->start() or, in its absence, by the time
input_register_handle() returns, events from input drivers will be
passed into the handle being registered, i.e. the presence of the
new item in the list is noticed by all CPUs.

Now, it is possible to stop using RCU primitives in the input core
but I think that you'd want to figure out why synchronize_rcu()
takes so long first, otheriwse you may find another "abuser"
down the road.

-- 
Dmitry

