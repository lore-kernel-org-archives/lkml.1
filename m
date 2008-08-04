Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbYHDOMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbYHDOMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755606AbYHDOMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:12:44 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:59714 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbYHDOMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:12:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ZqdoGOLJT34V/AunrW5FzFxTgQQRSHyxQfKSTeAPpD5iFrj7hn9axU2B+oMnPtEGqB
         DW33XdK4j4JqJSSQ4S/9fDGqs/nbNCx1kdDbT/hnKKPZ6QNOQdP2+nwNp3cDLxo/1J6X
         X/aUaLD2A4XFswb/R8ZeINaO6ZMFEp5yJOBE0=
Message-ID: <48970E34.9000706@gmail.com>
Date: Mon, 04 Aug 2008 23:12:04 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] libata: Implement disk shock protection support
References: <87prp1kvyy.fsf@denkblock.local>	<20080726062142.29070.10413.stgit@denkblock.local>	<4892B8FE.1070400@gmail.com> <87proooqry.fsf@denkblock.local>
In-Reply-To: <87proooqry.fsf@denkblock.local>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns wrote:
>> For libata, the easiest way to achieve the above would be adding a
>> per-dev EH action, say, ATA_EH_UNLOAD and schedule EH w/ the action OR'd
>> to eh_info->action.  The EH_UNLOAD handler can then issue the command
>> wait for the specified number of seconds and continue.  This will be
>> pretty simple to implement as command exclusion and stuff are all
>> automatically handled by EH framework.
> 
> I'm rather afraid this approach is impractical or unfavourable at the
> very least. Depending on the configured thresholds, a head unload
> request might well be issued unintentionally, e.g. by accidentally
> knocking against the table. It is quite alright for the HD to stop I/O
> for a moment but if the secondary device on the interface happens to be
> a CD writer, it will be very annoying to have CD writing operations fail
> due to minor percussions.

Why would it fail?

> Also, if there are two devices on the same
> port that support the UNLOAD FEATURE and you issue a head unload request
> to both of them in close succession, the IDLE IMMEDIATE to the second
> device will be blocked until the timeout for the first has expired.

Unload can be implemented as port-wide operation so that it issues IDLE
IMMEDIATE to all drives on the port but given that this is mostly for
laptop, this discussion is a bit peripheral.

-- 
tejun
