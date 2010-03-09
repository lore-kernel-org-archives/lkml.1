Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab0CIIGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 03:06:25 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:64731 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab0CIIGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 03:06:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nKscV0wYaabxiAx9nKjOpb28QVQjg5dyp6AavubE3vPMnfe6K+cS59xueboAFuEy7q
         PlEeMl/JHqyVnFdF0rhp9h1MqJXPoVeF7bUI/6ynPgZ7hgJIpNGRMlsi+e5XizNm75aq
         DsaWfivCgnwrnSCaDiq7yVDjK/yWEb0GLaShM=
Date: Tue, 9 Mar 2010 00:06:16 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Micki Balanga <micki@n-trig.com>
Cc: Rafi Rubin <rafi@seas.upenn.edu>, jkosina@suse.cz, chatty@enac.fr,
       peterhuewe@gmx.de, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: N-trig Finger Pen Multitouch fix
Message-ID: <20100309080616.GF17288@core.coreip.homeip.net>
References: <48A28051AC6D7A48B64F28272458190301AF29@Exchange-IL.n-trig.com>
 <4B94541C.5090509@seas.upenn.edu>
 <48A28051AC6D7A48B64F28272458190324F4F3@Exchange-IL.n-trig.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A28051AC6D7A48B64F28272458190324F4F3@Exchange-IL.n-trig.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Micki,

On Mon, Mar 08, 2010 at 03:11:08PM +0200, Micki Balanga wrote:
> 
> 
> -----Original Message-----
> From: Rafi Rubin [mailto:rafi@seas.upenn.edu] 
> Sent: Monday, March 08, 2010 3:34 AM
> To: Micki Balanga
> Cc: jkosina@suse.cz; chatty@enac.fr; peterhuewe@gmx.de;
> linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] USB: N-trig Finger Pen Multitouch fix
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> First let me thank you for contributing to the development of this
> driver.
> 
> 
> I suggest you use scripts/checkpatch.pl it will catch a number of style
> issues.
>  Dmitry was kind enough to point it out when I sent in my recent set of
> patches.
> 
> [Micki] I used the script to check the patch
> 
> Mostly it looks like this patch is the delta from an almost completely
> independently developed driver.  That makes it considerably more work to
> analyze
> the fundamental differences.  I would have preferred to see a set of
> patches
> which first mutate the existing code to match your naming conventions
> (if that
> is so desired) and then patches that show how things are actually
> different (A
> lesson I've learned the hard way).
> 
> I see quite a number of changes that handle the protocol better than my
> version,
> would you be offended if I begin to absorb those and submit joint
> patches?  I'm
> not sure about the proper etiquette for that.
> 
> [Micki] As mentioned in my mail we have tested the driver with
> application develop by N-trig. 
> [Micki] Our user space application rely on these events, so if you want
> to make any change I will be happy if you 
> [Micki] consult me.
> 

No, this is not how it works. There are already existing userspace
drivers/applications working with current n-trig driver, the fact that
your changes happen to work with your userspace is not enough.


> On 03/07/10 14:04, Micki Balanga wrote:
> > The purpose of this patch is to enable Linux users to experience the
> > complete N-trig DuoSense pen and true multi-touch solution
> capabilities
> > over a Linux platform. This driver has been carefully and thoroughly
> > tested by N-trig, over a period of several months.
> 
> What user space tools have you tested this driver with?  It does not
> seem to
> work well with the wacom and evdev drivers.
> 
> [Micki] We will put on N-trig web site a DEB package
> 

What about distributions not user deb?

> What improvements beyond the driver that's in 2.6.33 are you targeting?
> 
> [Micki] We will update the driver and user space application with new
> features.

What about other applications? You are not working in a vacuum. Please
consider working with X evdev and wacom developers - I am pretty sure
distributions would prefer a single userspace component supporting wide
range of multitouch devieces.  Consider how Synaptics X driver
(coincidentially not developed by Synaptisc) happens to support pretty
much every non-multitouch touchpad that is supported by Linux.

> 
> > + * The driver will support MTM firwmare Pen, Finger (Up to 6)
> 
> Is this code intended to support older firmwares as well?  It would be
> best not
> to break the driver for users with legacy firmwares without reason.
> 
> [Micki] There will be a DEB package for firmware upgrade.

You surely do not expect users to rush and upgrade their fimwares
en-masse? The dirver should support devices with both older and newer
firmwares (obviously devices with newer firmware will have wider set of
features).

> 
> > +#define PEN_REPORT_SIZE                0x48
> > +#define MAX_FINGERS_SUPPORT    0x06
> 
> Are these guaranteed to be kept constant for the foreseeable future?
> I've
> already seen hints that N-Trig may move to 10+ fingers in the not to
> distant future.
> 
> http://www.n-trig.com/Content.aspx?Page=PressReleases&PressReleaseId=541
> 
> I was starting to move to non-fixed finger limits before I pulled the
> finger
> tracking code.
> 
> > -       if (field->application == HID_DG_PEN)
> > -               return 0;
> 
> > +               if (PEN_REPORT_SIZE == field->report->size) {
> 
> What was wrong with using field->application to detect the pen?  On a
> side note,
> after splitting the touch and pen events to separate input devices, I
> found that
> the pen events conform quite well to the hid spec and don't need special
> handling.  Is there something I missed?
> 
> [Micki] Report Pen is constant , but I will look into it, as you
> mentioned in your mail 
> 
> > +#define MODULE_NAME "hid_ntrig"
> > +
> > +
> > +#define info(format, arg...) \
> > +       printk(KERN_INFO "%s: " format , MODULE_NAME , ## arg)
> > +#define ntrig_dbg(format, arg...) \
> > +       do { \
> > +               if (debug) \
> > +                       printk(KERN_DEBUG "%s: " format, \
> > +                       MODULE_NAME , ## arg); \
> > +       } while (0)
> 
> >  static struct hid_driver ntrig_driver = {
> >         .name = "ntrig",
> 
> Might want to use the #define for that too.
> 
> [Micki] : Not A Problem I will change it. 
> 
> 
> > +                       case HID_DG_CONTACTCOUNT:
> > +                               nt_rpt->real_fingers = value;
> > +                               nt_rpt->fake_fingers =
> > MAX_FINGERS_SUPPORT - value;
> 
> > +                                               if
> (MAX_FINGERS_SUPPORT
> > == nt_rpt->fake_fingers--) {
> 
> Would you care to explain "fake_fingers"?  I'm not really seeing why it
> helps
> when you already have real_fingers.  It looks like you use that to
> detect some
> ghost events, but really again, fingers should be fine at that point.
> 
> That does remind me that I pulled that special case when I cleaned up my
> last
> patch set and forgot to put it back.
> 
> Are the fake finger events intentional or just a bug?
> [Micki] As I mentioned before we developed a user space application
> which analyze the data 
>         Transferred from driver and the driver need to report about fake
> fingers.

This is not a technical argument ;(

-- 
Dmitry
