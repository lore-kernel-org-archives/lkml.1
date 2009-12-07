Return-Path: <linux-kernel-owner+w=401wt.eu-S964883AbZLGR4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964883AbZLGR4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964861AbZLGR4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:56:45 -0500
Received: from thsmsgxrt12p.thalesgroup.com ([192.54.144.135]:46610 "EHLO
	thsmsgxrt12p.thalesgroup.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964860AbZLGR4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:56:45 -0500
Message-ID: <4B1D415F.5090308@thalesgroup.com>
Date: Mon, 07 Dec 2009 18:54:39 +0100
From: =?ISO-8859-1?Q?Emmanuel_Fust=E9?= <emmanuel.fuste@thalesgroup.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR system?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:

> In summary,
>
> While the current EVIO[G|S]KEYCODE works sub-optimally for scancodes up to 16 
> bytes
> (since a read loop for 2^16 is not that expensive), the current approach
> won't scale with bigger scancode spaces. So, it is needed expand it
> to work with bigger scancode spaces, used by more recent IR protocols.
>
> I'm afraid that any tricks we may try to go around the current limits to still
> keep using the same ioctl definition will sooner or later cause big headaches.
> The better is to redesign it to allow using different scancode spaces.
>
>
>   
I second you: input layer events from drivers should be augmented with a
protocol member, allowing us to define new ioctl and new ways to
efficiently store and manage sparse scancode spaces (tree, hashtable
....). It will allow us to abstract the scancode value and to use
variable length scancode depending on the used protocol, and using the
most appropriate scheme to store the scancode/keycode mapping per protocol.
The today scancode space will be the legacy one, the default if not
specified "protocol". It will permit to progressively clean up the
actual acceptable mess in the input layer and finally using real
scancode -> keycode mappings everywhere if it is cleaner/convenient.

Best regards,
Emmanuel.


