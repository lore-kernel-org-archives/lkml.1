Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbYDACML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbYDACML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 22:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbYDACL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 22:11:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:53749 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbYDACL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 22:11:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: Re: [RFC PATCH 19/26] UBIFS: add Garbage Collector
Date: Tue, 1 Apr 2008 04:11:39 +0200
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <1206629746-4298-20-git-send-email-Artem.Bityutskiy@nokia.com>
In-Reply-To: <1206629746-4298-20-git-send-email-Artem.Bityutskiy@nokia.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804010411.39722.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+JoVJUANbhOcOdM5MoOrxCSok2lBJW0SscbJI
 +A2qV0tq4oQScGfhDuxgu19SluMDgirPYxyRfOEsRUoHwYRKmc
 B5ELIpkE6oHkBkawwuSbg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 March 2008, Artem Bityutskiy wrote:
> + * Note, if the file-system is close to be full, this function may return
> + * %-EAGAIN infinitely, so the caller has to limit amount of re-invocations of
> + * the function. E.g., this happens if the limits on the journal size are too
> + * tough and GC writes too much to the journal before an LEB is freed. This
> + * might also mean that the journal is too large, and the TNC becomes to big,
> + * so that the shrinker is constantly called, finds not clean znodes to free,
> + * and requests commit. Well, this may also happen if the journal is all right,
> + * but another kernel process consumes too much memory. Anyway, infinite
> + * %-EAGAIN may happen, but in some extreme/misconfiguration cases.

This comment sounds a little bit scary, but that may only be because I don't
understand the worst-case scenario.

Why can't you guarantee that there is always enough space to successfully
run GC, e.g. by reserving some space that can never be used by file data?

More importantly, if you get into the situation that the GC doesn't make
forward progress any more, can you guarantee that it is always possible
for the user to delete files in order to make space again? Or can you
get an -ENOSPC on unlink in that case?

	Arnd <><
