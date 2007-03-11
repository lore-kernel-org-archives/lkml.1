Return-Path: <linux-kernel-owner+w=401wt.eu-S932317AbXCKVC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbXCKVC7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 17:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932322AbXCKVC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 17:02:59 -0400
Received: from raven.upol.cz ([158.194.120.4]:42068 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317AbXCKVC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 17:02:58 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Trent Piepho <xyzzy@speakeasy.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFC PATCH 1/3] Add ability to keep track of callers of symbol_(get|put)
In-Reply-To: <20070311000938.80202418.akpm@linux-foundation.org>
References: <1173501095.26213.405.camel@localhost> <20070311000938.80202418.akpm@linux-foundation.org>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: jed + slrn/0.9.8.1pl1 (x86_64-linux-gnu-debian)
Date: Sun, 11 Mar 2007 22:12:27 +0100
Message-Id: <E1HQVL9-0007nM-I0@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andrew Morton
> Newsgroups: gmane.linux.kernel
> Subject: Re: [RFC PATCH 1/3] Add ability to keep track of callers of symbol_(get|put)
> Date: Sun, 11 Mar 2007 00:09:38 -0800
>
>> On Sat, 10 Mar 2007 02:31:35 -0200 Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
>> From: Trent Piepho <xyzzy@speakeasy.org>
>> 
>> When a module uses symbol_get() to increase the ref count of another
>> module, there is no record what module called symbol_get().  A module
>> can
>> show up as having other users, but there is no way to tell who those
>> users are.
>> 
>> This adds that ability to symbol_put() and symbol_get().
>
> One day I'll write a script which unwordwraps patches and then you'll all
> need to find new ways of torturing me.

I don't support twisted patches, but before they will be resent, because
word wrapping may lead to 80-colums rule, please find useful this:

sed -r '
# assume only line started from [+-] got wrapped
# start what ever first line
/^[-+]/{
:more;
# append next line, to check wrapped addition
N;
# if it is one, i.e starts not with [ \t+-], '@@' or 'diff'
# do "\n" -> " "
s_\n([^d@ \t+-])_ \1_g;
# loop until find one(addition), because line(s) already here
T more;
# special case of empty line
s_\n$_&_
t more;
b;
};'
____
