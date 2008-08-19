Return-Path: <linux-kernel-owner+w=401wt.eu-S1757132AbYHSRst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132AbYHSRst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 13:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756582AbYHSRro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 13:47:44 -0400
Received: from web50112.mail.re2.yahoo.com ([206.190.39.149]:21462 "HELO
	web50112.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756556AbYHSRrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 13:47:42 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Aug 2008 13:47:42 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=tVy7mdL2UR9tvInqFDs0Xhxe+5lpMAqGN67A6BbCilbk2syjAmh8dk454yscxaKaxiPk1NQFIZTRg4IuyBaVqBzXrLSouAbUdHcQe/wdHOO0Q6o+1s8aDGgFv+QglPFPWhGVtmk/uRObekaBWTw0VE/qp84zRE/2/d3vUD6JGqk=;
X-YMail-OSG: Zfe5aj0VM1lh4qmHbmkH4isbCpUD4iP1Ie8EwUXIk9g7NWRi8EJp9NZiqyhpmu3F.VkNGiSYX2owh6tbvdSJkoNrZURjU.tpf9EeuYuS5LsI7imDPhYnPAQIMovpA5davzOjjsoat.NTW8n8YClZZjE-
Date: Tue, 19 Aug 2008 10:41:01 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: RE: Linux 2.6.26 edac errors and ASUS P5W DH Deluxe motherboard
To: Andy Chittenden <andyc@bluearc.com>, linux-kernel@vger.kernel.org
In-Reply-To: <0F10A59FDFFDFD4E9BEBD7365DE672550214F0B1@uk-email.terastack.bluearc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <472120.81746.qm@web50112.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andy Chittenden <andyc@bluearc.com> wrote:

> 
> If you could let me know what I need to put in /etc/edac/labels.db, that
> would be appreciated too.
> 

This becomes a manual, one time, event, to discover the mapping of DIMMs to the silkscreen.

One command is the 'dmidecode' which is run as root and dumps the BIOS DMI Tables. Unfortunately,
many BIOSes do not correctly set these tables properly to the correct DIMM silk screen labels.
Because of this lack, EDAC and edac-utils was created to provide mechanism for end users.

If your system does provide correct DIMM Labels, you can create/correct the entry for your
motherboard in the database file for edac-utils.

If your system provides simple generic labels, then you will need to physically move DIMMs from
slot to slot and watching as the error "moves" with the DIMM. This will take a few iterations and
a state table.

Usually, a DIMM will have 2 Chip-Select Rows (csrow)

The first set of DIMMs form a 128-bit data path (called dual channel operation) and have csrows 0
and 1

The second set of DIMMs will have csrows 2 and 3.

Therefore, you need to examine which csrow and which channel the error is being reported in.

doug t


W1DUG
