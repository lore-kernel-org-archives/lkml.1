Return-Path: <linux-kernel-owner+w=401wt.eu-S1758558AbYG2RYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558AbYG2RYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757381AbYG2RYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:24:18 -0400
Received: from gw.goop.org ([64.81.55.164]:57337 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757296AbYG2RYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:24:17 -0400
Message-ID: <488F523C.7090201@goop.org>
Date: Tue, 29 Jul 2008 10:24:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: davecb@sun.com
CC: Ray Lee <ray-lk@madrabbit.org>, Oliver.Soltys@rsel.renesas.com,
       linux-kernel@vger.kernel.org
Subject: Re: directory sort order no longer beginning with "." and ".."?
References: <488EE7BF.4020908@rsel.renesas.com> <488F2EDA.2090709@goop.org> <2c0942db0807290935s67eba63te5bb826a0ab7c752@mail.gmail.com> <488F4F30.1070903@sun.com>
In-Reply-To: <488F4F30.1070903@sun.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Collier-Brown wrote:
> Alas, this implementation side-effect dates back to v6[1], and is so
> depended upon that even  CD filesystems, which are by no means Unix-like,
> contain dummy "." and ".." entries[2].

Er, no, I wouldn't call '.' and '..' implementation side-effects in 
themselves.  They're one of the particularly clever parts of the 
filesystem/namespace design.  I would agree that the specific 
implementation using "link" and "unlink" was a bit of a hack, and adding 
proper "mkdir" and "rmdir" made the world a better place.

>  I'd recommend either reproducing it or starting a project
> to hunt down and kill all the programs which assume it (;-))

Well, '.' and '..' are guaranteed to be somewhere in a (linked) 
directory, so all filesystems are required to make sure they exist 
somewhere, and programs which expect them to exist are perfectly within 
their rights.  But not necessarily the first two entries.

    J
