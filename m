Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbZCLE0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbZCLE0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 00:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbZCLE0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 00:26:15 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:51090 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbZCLE0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 00:26:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YfhMpHWkYbvANZ2PS11M4wJ9ibqHEaR60W4Kn8hbOoA8usSWdo+SlBInpKoQ2l8I3n
         qQx5ifL2mVUW28vNqe93RuocoMonZFIV6T1wA5Ci/RaW+6bfX7qSVRAN/lohjFUMFCx8
         3anJm9pJ1z7reixauAs4917jxWhaK30IgsUP8=
Message-ID: <49B88EE0.2000208@gmail.com>
Date: Wed, 11 Mar 2009 22:26:08 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: n0diamond@yahoo.co.jp
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Off-by-one in both LIBATA and IDE drivers
References: <20090312022825.44571.qmail@web4106.mail.ogk.yahoo.co.jp>
In-Reply-To: <20090312022825.44571.qmail@web4106.mail.ogk.yahoo.co.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Norman Diamond wrote:
> There's next to nothing that I can do about it.
> If the BIOS sets the Intel chip to present an ATA
> interface then the IDE drivers take control early in
> the boot process.  If the BIOS sets the Intel chip to
> present a SATA interface then LIBATA takes control
> early in the boot process.
> 
> I'm considering constructing a boot menu where the
> default command line has hda=noprobe hdb=noprobe
> hdc=noprobe hdd=noprobe, and an alternate boot option
> omits those.  Even if this will be reliable enough, it
> won't be easy to explain to customers (if you don't
> believe that then read some tech support stories).

I think that at some point the IDE drivers were updated to be less
aggressive about taking control of anything that looked like an IDE
controller, but I'm not certain. These kind of problems are kind of
inevitable when you configure two drivers that will attach to the same
device, it's hard to control which one will attach. (It's especially bad
if two drivers will attach to different parts of the same controller,
which is the combined mode fiasco we had for a while.)

Newer distributions like Fedora are generally setting CONFIG_IDE=n
entirely and avoid the problem.

> 
>> Realistically, although some people still work on
>> it, testing coverage of the old IDE drivers is not
>> that great these days, since most distributions no
>> longer use it.
> 
> Even Knoppix 6.0.1, whose kernel isn't too antique
> yet, assigned /dev/hda and /dev/hdc on my Dell D820
> with ICH7M.
> 
> --------------------------------------
> Power up the Internet with Yahoo! Toolbar.
> http://pr.mail.yahoo.co.jp/toolbar/

