Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbYKUOyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbYKUOyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 09:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbYKUOyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 09:54:11 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:7895 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbYKUOyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 09:54:10 -0500
Message-ID: <154e089b0811210654v45126cbene22d925a1760d9e2@mail.gmail.com>
Date: Fri, 21 Nov 2008 15:54:08 +0100
From: "Hannes Eder" <hannes@hanneseder.net>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH] CRED: fix compilation warning in function 'get_cred'
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <11321.1227219571@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <154e089b0811201400w6b5d249eyc21ebb9a76133d08@mail.gmail.com>
	 <11321.1227219571@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 11:19 PM, David Howells <dhowells@redhat.com> wrote:
> Hannes Eder <hannes@hanneseder.net> wrote:
>
>> Fix to following warning by introducing a temporary variable:
>>
>> include/linux/cred.h: In function 'get_cred':
>> include/linux/cred.h:187: warning: passing argument 1 of
>> 'get_new_cred' discards qualifiers from pointer target type
>
> Interesting.  I believe that's a compiler bug.  Explicitly casting away the
> const should avoid this warning.

Strange. I think you are right, looks like a compiler bug.  I am using
gcc (GCC) 4.2.4 (Ubuntu 4.2.4-1ubuntu3).  Compiling the following code
snippet does not yield a spurious warning:

struct foo {
	int a;
};

static inline struct foo *bar(struct foo *foo)
{
	foo->a++;
	return foo;
}

static inline const struct foo *bar2(const struct foo *foo)
{
	return bar((struct foo*)foo);
}

What do you suggest, report this as a gcc bug?

-Hannes
