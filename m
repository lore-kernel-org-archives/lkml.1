Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbYABKxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbYABKxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 05:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbYABKxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 05:53:05 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:53338 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbYABKxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 05:53:04 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC] sleepy linux
Date: Wed, 2 Jan 2008 11:52:51 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20071225230731.GA29030@elf.ucw.cz> <200712301739.42192.oliver@neukum.org> <20071231144447.GD26339@ucw.cz>
In-Reply-To: <20071231144447.GD26339@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801021152.52639.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 31. Dezember 2007 15:44:47 schrieb Pavel Machek:
> On Sun 2007-12-30 17:39:42, Oliver Neukum wrote:

> > But what's wrong with calling suspend() the conventional way once you've
> > decided to go into sleepy mode?
> 
> I'm not sure if it can be done in non-racy way. It is different from
> "conventional" suspend(): you can still have userland requests after
> this suspend(), and you should abort auto-sleep if you get one. (As
> opposed to blocking in system suspend case).

But we are always racing against hardware in these cases.

Strictly speaking you cannot have pure userland request. If no task
is runnable and no timer about to fire any activity will require kernel
activity unless you are doing direct hardware access from user space
which in the generic case precludes suspension anyway.

	Regards
		Oliver
