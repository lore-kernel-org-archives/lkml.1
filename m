Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbXFUTTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbXFUTTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbXFUTTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:19:38 -0400
Received: from terminus.zytor.com ([192.83.249.54]:33289 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbXFUTTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:19:36 -0400
Message-ID: <467ACF37.8050504@zytor.com>
Date: Thu, 21 Jun 2007 12:19:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Hans-Peter Jansen <hpj@urpla.net>
CC: linux-kernel@vger.kernel.org, "Dr. David Alan Gilbert" <linux@treblig.org>,
       Karel Zak <kzak@redhat.com>, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that
 through other means
References: <467994BD.6000403@zytor.com> <20070620224135.GC6258@gallifrey> <4679AE5E.4050001@zytor.com> <200706212114.25705.hpj@urpla.net>
In-Reply-To: <200706212114.25705.hpj@urpla.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hans-Peter Jansen wrote:
>> That's already handled just fine:
>>
>> bash-3.1$ mkdir /tmp/'Jag är: \
>> en liten mask'
>> bash-3.1$ sudo mount -t tmpfs none '/tmp/Jag är: \
>> en liten mask'/
>> bash-3.1$ tail -1 /proc/mounts
>> none /tmp/Jag\040är:\040\134\012en\040liten\040mask tmpfs rw 0 0
>> bash-3.1$
> 
> Hmm, and what about the even sicker case: /tmp/\040, parse as /tmp/\\040?
> Do userspace cope with this?

Look at the example above, it contains a backslash already.  It's
escaped as \134.

"Does userspace cope with this" is of course an impossible question to
answer, since userspace is in theory unbounded.  However, if it doesn't,
it is broken and needs to be fixed.

	-hpa
