Return-Path: <linux-kernel-owner+w=401wt.eu-S1762103AbYC2DQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762103AbYC2DQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758607AbYC2DQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:16:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63782 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083AbYC2DQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:16:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 1/7] omfs: define filesystem structures
Date: Sat, 29 Mar 2008 04:15:41 +0100
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <1206578760-9050-1-git-send-email-me@bobcopeland.com> <20080328201940.GA3974@ucw.cz> <20080328231833.GA16515@hash.localnet>
In-Reply-To: <20080328231833.GA16515@hash.localnet>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803290415.43189.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18U8oxgSzVYjBTJh2ZYISLfpFKup2miSwuPqp5
 0qAMDzk82s8v8XO7a7Pu2ZIKo7BTYqH31HnEC3bkWtUp/8kKMx
 MflJuXnP3QWgvkIeItqeA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 March 2008, Bob Copeland wrote:
> On Fri, Mar 28, 2008 at 09:19:40PM +0100, Pavel Machek wrote:
> > On Wed 2008-03-26 20:45:54, Bob Copeland wrote:
> > > +struct omfs_header {
> > > +   __be64 h_self;
> > > +   __be32 h_body_size;
> > > +   __be16 h_crc;
> > > +   char h_fill1[2];
> > > +   u8 h_version;
> > > +   char h_type;
> > > +   u8 h_magic;
> > > +   u8 h_check_xor;
> > > +   __be32 h_fill2;
> > > +};
> > 
> > attribute packed or something? Some strange machine (alpha?) may
> > decide to align u8s at 32bit boundaries...
> 
> Thanks, I guess this applies for all the on disk structs.

Actually, we don't normally add the attribute((packed)) in cases like
this one, where you already have manual padding in it. Marking this
structure packed would only cause a small performance loss on accesses
of its members on certain architectures, but not have an impact on
correctness.

No architecture supported by Linux requires higher than natural alignment
for any integer types, and a lot of other code would break otherwise.

	Arnd <><
