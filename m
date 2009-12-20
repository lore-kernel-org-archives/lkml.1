Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbZLTMsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbZLTMsL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 07:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbZLTMsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 07:48:10 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39693 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbZLTMsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 07:48:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=V3G481cd8EyLZ6eqbpFHSvD4d/OGfEmRHzo36L65iIvQhlcH32lEgIPxB+fWWYcogH
         XejNxKWZqMh0QyyT5RqV2iKZCW4uQATXyvk4Z871QCuQIEBFMy9SbhFQrBVSfzsBx4v/
         OodyystBrktdDeal1vYHHfDaNzDpL9HPv5lQc=
MIME-Version: 1.0
Date: Sun, 20 Dec 2009 15:48:05 +0300
Message-ID: <a4423d670912200448s357e273fm9cee1d958fe2be91@mail.gmail.com>
Subject: tty: tty_port_get() breaks build
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Alan Cox <alan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Commit is 568aafc62
tty: tty_port: Add a kref object to the tty port

include/linux/tty.h:469: error: '______f' is static but declared in
inline function 'tty_port_get' which is not static

tty_port_get() looks as

extern inline __attribute__((always_inline)) struct tty_port
*tty_port_get(struct tty_port *port)
{
 if (__builtin_constant_p(((port))) ? !!((port)) : ({ int ______r;
static struct ftrace_branch_data __attribute__((__aligned__(4)))
__attribute__((section("_ftrace_branch"))) ______f = { .func =
__func__, .file = "include/linux/tty.h", .line = 469, }; ______r =
!!((port)); ______f.miss_hit[______r]++; ______r; }))
  kref_get(&port->kref);
 return port;
}
