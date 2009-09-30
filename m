Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbZI3PdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbZI3PdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbZI3PdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:33:08 -0400
Received: from smtp-out.google.com ([216.239.45.13]:20638 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbZI3PdD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:33:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=pc+FkN4JaieRLVlJ6DJUz8TKTSmNr9mWtk/Sy5giZOSAJax0WTcLOe0mkM94+bbHY
	P8mwdeehU+m//f+dgHknw==
MIME-Version: 1.0
In-Reply-To: <20090930171833.5ce0011d@infradead.org>
References: <20090930131109.2b3f71b8@infradead.org> <4AC35F44.60707@google.com>
	 <20090930171833.5ce0011d@infradead.org>
Date: Wed, 30 Sep 2009 17:33:01 +0200
Message-ID: <b5ddba180909300833g2b1fd22ak3e094e10fe10e8a@mail.gmail.com>
Subject: Re: [PATCH] ipvs: Add boundary check on ioctl arguments
From: Hannes Eder <heder@google.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Wensong Zhang <wensong@linux-vs.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Simon Horman <horms@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 17:18, Arjan van de Ven <arjan@infradead.org> wrote:
> On Wed, 30 Sep 2009 15:38:12 +0200
> Hannes Eder <heder@google.com> wrote:
>>  > @@ -2353,17 +2357,25 @@ do_ip_vs_get_ctl(struct sock *sk, int cmd,
>>  > void __user
>> *user, int *len)
>>  >  {
>>  >    unsigned char arg[128];
>>
>> can MAX_ARG_LEN be used here?
>
> I am not convinced... it is a different numerical value,
> so it could be an ABI change. Rather not do that in this
> type of patch...

For do_ip_vs_set_ctl MAX_ARG_LEN is used:

static int
do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
{
	int ret;
	unsigned char arg[MAX_ARG_LEN];
...

I assume that will be fine for do_ip_vs_get_ctl as well.

-Hannes
