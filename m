Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbXGCNKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbXGCNKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 09:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbXGCNKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 09:10:05 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:45784 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbXGCNKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 09:10:03 -0400
Date: Tue, 3 Jul 2007 09:09:46 -0400
From: Chris Mason <chris.mason@oracle.com>
To: "Xin Zhao" <uszhaoxin@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: how do versioning filesystems take snapshot of opened files?
Message-ID: <20070703090946.49e6062f@think.oraclecorp.com>
In-Reply-To: <4ae3c140707022228u2b5098c5v766b9dc9a7e09ea1@mail.gmail.com>
References: <4ae3c140707022228u2b5098c5v766b9dc9a7e09ea1@mail.gmail.com>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007 01:28:57 -0400
"Xin Zhao" <uszhaoxin@gmail.com> wrote:

> Hi,
> 
> 
> If a file is already opened when snapshot command is issued,  the file
> itself could be in an inconsistent state already. Before the file is
> closed, maybe part of the file contains old data, the rest contains
> new data.
> How does a versioning filesystem guarantee that the file snapshot is
> in a consistent state in this case?
> 
> I googled it but didn't find any answer. Can someone explain it a
> little bit?

It's the same answer as in most filesystem related questions...it
depends ;)  Consistent state means many different things.  It may mean
that the metadata accurately reflects the space on disk allocated to
the file and that all data for the file is properly on disk (ie from an
fsync).

But, even this is less than useful because very few files on the
filesystem stand alone.  Applications spread their state across a
number of files and so consistent means something different to
every application.

Getting a snapshot that is useful with respect to application data
requires help from the application.  The app needs to be shutdown or
paused prior to the snapshot and then started up again after the
snapshot is taken.

-chris


