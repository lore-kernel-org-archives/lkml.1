Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbYDUJiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbYDUJiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 05:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbYDUJh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 05:37:57 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:36242 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbYDUJh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 05:37:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=rAqJg3Oh3CIi15aQAxYJcibfs89tIJU8/jMa8Im2YWVCVwvQj6WOoXBlezLqPpisBBOxW8Zh35x+71J3hXkjcvXY0Giv6bJgv+EoeM0WUCZXPX4Js9ltdCkiYBTdneoc4iFhdjszcQ+rL1zbmoUKUZkGfmEKkuYvFg8RXXI8cxc=
Message-ID: <480C6064.10801@gmail.com>
Date: Mon, 21 Apr 2008 11:37:40 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: fault in __d_lookup [Was: 2.6.25-mm1]
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org> <480C50EC.2090803@gmail.com> <20080421090610.GO27459@ZenIV.linux.org.uk>
In-Reply-To: <20080421090610.GO27459@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2008 11:06 AM, Al Viro wrote:
> On Mon, Apr 21, 2008 at 10:31:40AM +0200, Jiri Slaby wrote:
> 
>         hlist_for_each_entry_rcu(dentry, node, head, d_hash) {
>                 struct qstr *qstr;
> 
>                 if (dentry->d_name.hash != hash)
>                         continue;
> 
> walking into node == (struct hlist_node *)0x00f0000000000000...

Yup, true, In the last oops I stuck on memcmp few lines below.

BTW. it's 100% reproducible after it happens once, but fixable by reboot. Any 
tests I should run (memtest, some printks sticked anywhere)?
