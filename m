Return-Path: <linux-kernel-owner+w=401wt.eu-S935583AbYEUU1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935583AbYEUU1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbYEUU1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:27:09 -0400
Received: from westnet.com ([216.187.52.2]:63656 "EHLO westnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207AbYEUU1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:27:08 -0400
Date: Wed, 21 May 2008 16:25:52 -0400 (EDT)
From: Greg Smith <gsmith@gregsmith.com>
X-X-Sender: gsmith@westnet.com
To: Jamie Lokier <jamie@shareable.org>
cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
In-Reply-To: <20080520151306.GF16676@shareable.org>
Message-ID: <Pine.GSO.4.64.0805211604270.7231@westnet.com>
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org>
 <482DF44B.50204@redhat.com> <20080516220315.GB15334@shareable.org>
 <20080519002838.GB8335@mit.edu> <20080520151306.GF16676@shareable.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008, Jamie Lokier wrote:

> I doubt if common unix mail transports use F_FULLSYNC on Darwin
> instead of fsync(), before reporting a mail received safely, but they
> probably should.  I recall SQLite does use it (unless I'm confusing
> it with some other database).

As far as I know that made its way first into MySQL 4.1.9 (2005-01), then 
into SQLite (2005-02), then into PostgreSQL (2005-04), so the database 
coders all picked that up around the same time and have been using it for 
years now.

http://www.mail-archive.com/sqlite-users@sqlite.org/msg06502.html shows 
part of that timeline, and even includes some useful comments on the 
underlying Darwin implementation from that mailing list.  That suggests 
one reason Apple is able to make this work is that their selection process 
for hard drives requires the drive honors the request to flush its cache 
they send.  The implied caveat there is that even their F_FULLSYNC won't 
necessarily work with external Firewire/USB drives where that's out of 
their control.

--
* Greg Smith gsmith@gregsmith.com http://www.gregsmith.com Baltimore, MD
