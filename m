Return-Path: <linux-kernel-owner+w=401wt.eu-S1753037AbYIEUzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbYIEUzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 16:55:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbYIEUyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 16:54:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:15170 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbYIEUyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 16:54:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FJ4nqe8VwWxd/xtft4PYL8q05DH+kEgiEx+4UDRRZr+6wU8zTs4STceg/aQMyDufln
         mpKXEfDM75X7uMcdlpYDmOuvJoAm9cOz0nRBeZYIPkrzh+tiIKAYH52TQkUhMFjGyA8E
         64KojS5uEZi2heWHZU5v8CNgYxkQ+K8m9gfOs=
Message-ID: <c8b4dbe10809051354r2747b42atf15b3b6f9346987c@mail.gmail.com>
Date: Fri, 5 Sep 2008 21:54:51 +0100
From: "Aidan Thornton" <makosoft@googlemail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation support
Cc: "Markus Rechberger" <mrechberger@gmail.com>,
       "Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-dvb@linuxtv.org, mrechberger@sundtek.com
In-Reply-To: <20080831042115.GA21622@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48B8400A.9030409@linuxtv.org> <48B98914.1020800@w3z.co.uk>
	 <48B98B89.80803@linuxtv.org>
	 <d9def9db0808302057u25e7ce5yfb2967c893255df0@mail.gmail.com>
	 <20080831042115.GA21622@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2008 at 5:21 AM, Greg KH <greg@kroah.com> wrote:
> On Sun, Aug 31, 2008 at 05:57:46AM +0200, Markus Rechberger wrote:
>> Let's put another thing in here: Greg Kroah Hartman Linux Guy reverted
>
> If you're going to spell my full last name out, please get it right, you
> forgot a '-' :)
>
>> my patch in favour of supporting the binary Firmware upload tool of
>> Dell (I fully support Dell here too) although claiming to be
>> opensource but still running after someone (please comment this one -
>> it confused me at 'your' position). It was just like ok let's revert
>> it but not asking why?!
>
> What patch specifically are you referring to here?
>
> And what does this have to do with v4l and DVB issues?
>
> thanks,
>
> greg k-h

Hi,

Markus submitted a patch to the firmware loader code that fixed a
sysfs filename collision by appending a suffix to the sysfs filename
it used. This bug broke the use of the firmware loader from i2c device
drivers (specifically, the drivers for the xc3028 TV tuner chip) with
certain (not particularly unusual) kernel configurations - IIRC, it
affected kernels with I2C compiled as a module and a particular value
of some option related to sysfs depreciated support. The patch was
reverted by you because it broke binary-only firmware upload tools for
Dell hardware, screwing over normal desktop users in the process.

See, for example, http://lkml.org/lkml/2008/4/26/319 - this is fairly
typical. IIRC, the only drivers for the xc3028 that aren't affected
are Markus' recent ones, since they compile the firmware into the
driver (ugh). This may have been fixed since, but I'm not sure.

(Incidentally, looking at the conversation, I believe your remark that
"the i2c devices can fix things by changing their module names so this
collision doesn't happen :)" may be inaccurate. The firmware loader
copies the name it uses from the device passed to it, so I'm not sure
how much can be done, short of hacking around the issue by creating a
fake device to pass to the firmware loader or making potentially
compatibility-breaking changes to either the i2c core or the firmware
loader. Of course, I haven't looked at the issue that closely, so I
may be wrong.)

Aidan
