Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137AbZAHLPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbZAHLPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 06:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbZAHLPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 06:15:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37585 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758188AbZAHLPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 06:15:39 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <496535D9.6040606@gmail.com>
References: <496535D9.6040606@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: dhowells@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>
Subject: Re: broken daemonize (COW credentials?)
Date: Thu, 08 Jan 2009 11:15:11 +0000
Message-ID: <25299.1231413311@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jirislaby@gmail.com> wrote:

> I'm observing daemonize crashes with this code:

I'm not seeing daemonize() crash, but I can see how it might - depending on
the changes to the creds made by daemonize().  commit_creds() should only call
set_dumpable() if task->mm is not NULL.

David
