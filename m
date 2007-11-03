Return-Path: <linux-kernel-owner+w=401wt.eu-S1758435AbXKCEer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbXKCEer (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 00:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbXKCEek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 00:34:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbXKCEej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 00:34:39 -0400
Message-ID: <472BFA4B.9040506@redhat.com>
Date: Fri, 02 Nov 2007 21:34:19 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: [patch] PID namespace design bug, workaround
References: <20071101144307.GA29566@elte.hu>	<4729E7E4.8070208@openvz.org>	<4729E936.4040400@redhat.com>	<4729EB3C.9050102@openvz.org>	<472A6D91.1020300@redhat.com>	<472AD7D6.80900@openvz.org> <20071102010419.23f3db5c.akpm@linux-foundation.org> <472ADC78.6070706@openvz.org> <472B2EBD.7070007@redhat.com> <472B327E.2060006@openvz.org> <472B4378.80809@redhat.com> <472B4937.1050106@openvz.org>
In-Reply-To: <472B4937.1050106@openvz.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Pavel Emelyanov wrote:
> Having access to the same IPCs in different pid namespaces won't work.
> Having access to the same filesystem in different IPC namespaces won't work.
> Having access to the same UID namespace in different VFS namespaces won't work.
> Having access to the same <any> namespace in different <many others> namespace
>  wont' work.
> [...]


Then explicitly prevent the cases which cannot work in the clone()
calls.  Yes, giving people rope to shoot themselves is a Unix tradition
but it's so unnecessary in this case and will only cause support
problems for innocent people.

I bet the result will be that if you have a separate PID namespace you
need to enforce every other namespace as well.  There are simply too
many dependencies.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHK/pL2ijCOnn/RHQRAtp6AKC8QIRvJa4qVUSx9IVpRq6X+6HPGQCff/hT
m2tpKWmeM+xAfS5ICvB0NVk=
=5ozn
-----END PGP SIGNATURE-----
