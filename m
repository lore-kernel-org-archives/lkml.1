Return-Path: <linux-kernel-owner+w=401wt.eu-S1757617AbZKJSuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617AbZKJSuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 13:50:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbZKJSuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 13:50:12 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:36462 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513AbZKJSuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 13:50:11 -0500
Message-ID: <4AF9B592.6030309@nortel.com>
Date: Tue, 10 Nov 2009 12:48:50 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: netdev@vger.kernel.org, Linux kernel <linux-kernel@vger.kernel.org>,
       twaugh@redhat.com
Subject: Re: sunrpc port allocation and IANA reserved list
References: <4AF9A63B.6010101@nortel.com> <1257875623.2834.19.camel@achroite.uk.solarflarecom.com> <4AF9B2CF.6050305@nortel.com>
In-Reply-To: <4AF9B2CF.6050305@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2009 18:50:12.0281 (UTC) FILETIME=[A237EA90:01CA6236]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 12:37 PM, Chris Friesen wrote:
> On 11/10/2009 11:53 AM, Ben Hutchings wrote:
>> On Tue, 2009-11-10 at 11:43 -0600, Chris Friesen wrote:
> 
>>> Given that a userspace application can be stopped and restarted at any
>>> time, and a sunrpc registration can happen at any time, what is the
>>> expected mechanism to prevent the kernel from allocating a port for use
>>> by sunrpc that reserved or well-known?
>>>
>>> Apparently Redhat and Debian have distro-specific ways of dealing with
>>> this, but is there a standard solution?  Should there be?
>>>
>>> The current setup seems suboptimal.
>>
>> I believe both RH and Debian are using the same implementation:
>> <http://cyberelk.net/tim/software/portreserve/>.
> 
> That helps with the startup case, but still leaves a possible hole if an
> app using a fixed port number is restarted at runtime.  During the
> window where nobody is bound to the port, the kernel could randomly
> assign it to someone else.

After some reflection it seems to me that the only way to close this
race condition is to store the list of reserved ports in the kernel and
simply avoid handing out a reserved address unless it is specifically
requested.

Maybe we could keep the config files of the existing portreserve
package, but rather than maintaining the reservation list itself the
portreserve app would simply feed the reservations into the kernel (via
/proc or netlink or something) at startup.

This would also avoid the need to modify the startup scripts of
applications wanting to use a fixed port.  The config file containing
the port number would still be necessary, however.

Chris
