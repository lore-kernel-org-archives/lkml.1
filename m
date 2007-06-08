Return-Path: <linux-kernel-owner+w=401wt.eu-S1030677AbXFHTXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030677AbXFHTXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbXFHTXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:23:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51852 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750795AbXFHTXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:23:33 -0400
Date: Fri, 8 Jun 2007 12:22:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Kirill Korotaev <dev@sw.ru>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH -mm 1/2] user namespace : add unshare
Message-Id: <20070608122215.5da4fa87.akpm@linux-foundation.org>
In-Reply-To: <4669723F.1040406@fr.ibm.com>
References: <4669723F.1040406@fr.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Jun 2007 17:14:07 +0200
Cedric Le Goater <clg@fr.ibm.com> wrote:

> Basically, it will allow a process to unshare its user_struct table, resetting
> at the same time its own user_struct and all the associated accounting.
> 
> A new root user (uid == 0) is added to the user namespace upon creation.  Such
> root users have full privileges and it seems that theses privileges should be
> controlled through some means (process capabilities ?)

This second paragraph is distressingly indecisive.  How much thought has
gone into this??

For a start, it seems wrong for the kernel to hardwire knowledge about UID
0 in this fashion.

I'd have thought that a better model for user-namespace unsharing would be
to do a copy-by-value of the entire namespace, then permit a
suitably-privileged application to go through and kill off any unwanted
users from the now-unshared user namespace.

Or maybe just remove that "Insert new root user" altogether?  What would
then go wrong?

