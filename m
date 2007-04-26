Return-Path: <linux-kernel-owner+w=401wt.eu-S1031348AbXDZRPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031348AbXDZRPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031362AbXDZRPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:15:43 -0400
Received: from dns2.vpop.net ([216.193.240.3]:1900 "EHLO thorin.vpop.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031348AbXDZRPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:15:41 -0400
X-Greylist: delayed 1796 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Apr 2007 13:15:41 EDT
In-Reply-To: <20070425174643.f1fc189d.akpm@linux-foundation.org>
References: <20070424100203.GB16473@2ka.mipt.ru> <20070425174643.f1fc189d.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: multipart/mixed; boundary=Apple-Mail-1--417236537
Message-Id: <50E54C86-53FA-4FEE-83ED-AB0BF2E56F48@vpop.net>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
From: Matt Reimer <mreimer@vpop.net>
Subject: Re: [2/2] Driver for the Maxim DS1WM, a 1-wire bus master ASIC core.
Date: Thu, 26 Apr 2007 09:45:42 -0700
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail-1--417236537
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed

On Apr 25, 2007, at 5:46 PM, Andrew Morton wrote:

> On Tue, 24 Apr 2007 14:02:03 +0400 Evgeniy Polyakov  
> <johnpol@2ka.mipt.ru> wrote:
>
>> +#define DS1WM_CMD_1W_RESET  1 << 0	/* force reset on 1-wire bus */
>> +#define DS1WM_CMD_SRA	    1 << 1	/* enable Search ROM accelerator  
>> mode */
>> +#define DS1WM_CMD_DQ_OUTPUT 1 << 2	/* write only - forces bus low */
>> +#define DS1WM_CMD_DQ_INPUT  1 << 3	/* read only - reflects state  
>> of bus */
>> +
>> +#define DS1WM_INT_PD	    1 << 0	/* presence detect */
>> +#define DS1WM_INT_PDR	    1 << 1	/* presence detect result */
>> +#define DS1WM_INT_TBE	    1 << 2	/* tx buffer empty */
>> +#define DS1WM_INT_TSRE	    1 << 3	/* tx shift register empty */
>> +#define DS1WM_INT_RBF	    1 << 4	/* rx buffer full */
>> +#define DS1WM_INT_RSRF	    1 << 5	/* rx shift register full */
>> +
>> +#define DS1WM_INTEN_EPD	    1 << 0	/* enable presence detect int */
>> +#define DS1WM_INTEN_IAS	    1 << 1	/* INTR active state */
>> +#define DS1WM_INTEN_ETBE    1 << 2	/* enable tx buffer empty int */
>> +#define DS1WM_INTEN_ETMT    1 << 3	/* enable tx shift register  
>> empty int */
>> +#define DS1WM_INTEN_ERBF    1 << 4	/* enable rx buffer full int */
>> +#define DS1WM_INTEN_ERSRF   1 << 5	/* enable rx shift register  
>> full int */
>> +#define DS1WM_INTEN_DQO	    1 << 6	/* enable direct bus driving ops
>> +					   (undocumented), Szabolcs Gyurko */
>
> These macros are very dangerous - please parenthesise them all.

(and several other helpful suggestions...)

Thanks for your review Andrew. I made all the code changes you  
suggested in the attached patch.

Matt

--Apple-Mail-1--417236537
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name=0001-w1-driver-for-Maxim-DS1WM.patch
Content-Disposition: attachment;
	filename=0001-w1-driver-for-Maxim-DS1WM.patch

=46rom=20b1f6ac622b85cbc08b96dbff3ccb5e0b3a8e1ad0=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Matt=20Reimer=20<mreimer@vpop.net>=0ADate:=20=
Thu,=2026=20Apr=202007=2009:39:30=20-0700=0ASubject:=20[PATCH]=20w1=20=
driver=20for=20Maxim=20DS1WM=0A=0AImplements=20a=20driver=20for=20the=20=
Maxim=20DS1WM=20ASIC=20core,=20used=20in=20most=20HP=0AiPAQs.=0A=0A=
Signed-off-by:=20Matt=20Reimer=20<mreimer@vpop.net>=0A---=0A=20=
drivers/w1/masters/Kconfig=20=20|=20=20=20=208=20+=0A=20=
drivers/w1/masters/Makefile=20|=20=20=20=202=20+-=0A=20=
drivers/w1/masters/ds1wm.c=20=20|=20=20461=20=
+++++++++++++++++++++++++++++++++++++++++++=0A=20include/linux/ds1wm.h=20=
=20=20=20=20=20=20|=20=20=2012=20++=0A=204=20files=20changed,=20482=20=
insertions(+),=201=20deletions(-)=0A=20create=20mode=20100644=20=
drivers/w1/masters/ds1wm.c=0A=20create=20mode=20100644=20=
include/linux/ds1wm.h=0A=0Adiff=20--git=20a/drivers/w1/masters/Kconfig=20=
b/drivers/w1/masters/Kconfig=0Aindex=202fb4255..ca44f9e=20100644=0A---=20=
a/drivers/w1/masters/Kconfig=0A+++=20b/drivers/w1/masters/Kconfig=0A@@=20=
-35,5=20+35,13=20@@=20config=20W1_MASTER_DS2482=0A=20=09=20=20This=20=
driver=20can=20also=20be=20built=20as=20a=20module.=20=20If=20so,=20the=20=
module=0A=20=09=20=20will=20be=20called=20ds2482.=0A=20=0A+config=20=
W1_DS1WM=0A+=09tristate=20"Maxim=20DS1WM=201-wire=20busmaster"=0A+=09=
depends=20on=20W1=0A+=09help=0A+=09=20=20Say=20Y=20here=20to=20enable=20=
the=20DS1WM=201-wire=20driver,=20such=20as=20that=0A+=09=20=20in=20HP=20=
iPAQ=20devices=20like=20h5xxx,=20h2200,=20and=20ASIC3-based=20like=0A+=09=
=20=20hx4700.=0A+=0A=20endmenu=0A=20=0Adiff=20--git=20=
a/drivers/w1/masters/Makefile=20b/drivers/w1/masters/Makefile=0Aindex=20=
4cee256..a9e45fb=20100644=0A---=20a/drivers/w1/masters/Makefile=0A+++=20=
b/drivers/w1/masters/Makefile=0A@@=20-5,4=20+5,4=20@@=0A=20=
obj-$(CONFIG_W1_MASTER_MATROX)=09=09+=3D=20matrox_w1.o=0A=20=
obj-$(CONFIG_W1_MASTER_DS2490)=09=09+=3D=20ds2490.o=0A=20=
obj-$(CONFIG_W1_MASTER_DS2482)=09=09+=3D=20ds2482.o=0A-=0A=
+obj-$(CONFIG_W1_DS1WM)=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20+=3D=20ds1wm.o=0Adiff=20--git=20a/drivers/w1/masters/ds1wm.c=20=
b/drivers/w1/masters/ds1wm.c=0Anew=20file=20mode=20100644=0Aindex=20=
0000000..3f984f5=0A---=20/dev/null=0A+++=20b/drivers/w1/masters/ds1wm.c=0A=
@@=20-0,0=20+1,461=20@@=0A+/*=0A+=20*=201-wire=20busmaster=20driver=20=
for=20DS1WM=20and=20ASICs=20with=20embedded=20DS1WMs=0A+=20*=20such=20as=20=
HP=20iPAQs=20(including=20h5xxx,=20h2200,=20and=20devices=20with=20ASIC3=0A=
+=20*=20like=20hx4700).=0A+=20*=0A+=20*=20Copyright=20(c)=202004-2005,=20=
Szabolcs=20Gyurko=20<szabolcs.gyurko@tlt.hu>=0A+=20*=20Copyright=20(c)=20=
2004-2007,=20Matt=20Reimer=20<mreimer@vpop.net>=0A+=20*=0A+=20*=20Use=20=
consistent=20with=20the=20GNU=20GPL=20is=20permitted,=0A+=20*=20provided=20=
that=20this=20copyright=20notice=20is=0A+=20*=20preserved=20in=20its=20=
entirety=20in=20all=20copies=20and=20derived=20works.=0A+=20*/=0A+=0A=
+#include=20<linux/module.h>=0A+#include=20<linux/interrupt.h>=0A=
+#include=20<linux/irq.h>=0A+#include=20<linux/pm.h>=0A+#include=20=
<linux/platform_device.h>=0A+#include=20<linux/clk.h>=0A+#include=20=
<linux/delay.h>=0A+#include=20<linux/ds1wm.h>=0A+=0A+#include=20=
<asm/io.h>=0A+=0A+#include=20"../w1.h"=0A+#include=20"../w1_int.h"=0A+=0A=
+=0A+#define=20DS1WM_CMD=090x00=09/*=20R/W=204=20bits=20command=20*/=0A=
+#define=20DS1WM_DATA=090x01=09/*=20R/W=208=20bits,=20transmit/receive=20=
buffer=20*/=0A+#define=20DS1WM_INT=090x02=09/*=20R/W=20interrupt=20=
status=20*/=0A+#define=20DS1WM_INT_EN=090x03=09/*=20R/W=20interrupt=20=
enable=20*/=0A+#define=20DS1WM_CLKDIV=090x04=09/*=20R/W=205=20bits=20of=20=
divisor=20and=20pre-scale=20*/=0A+=0A+#define=20DS1WM_CMD_1W_RESET=20=20=
(1=20<<=200)=09/*=20force=20reset=20on=201-wire=20bus=20*/=0A+#define=20=
DS1WM_CMD_SRA=09=20=20=20=20(1=20<<=201)=09/*=20enable=20Search=20ROM=20=
accelerator=20mode=20*/=0A+#define=20DS1WM_CMD_DQ_OUTPUT=20(1=20<<=202)=09=
/*=20write=20only=20-=20forces=20bus=20low=20*/=0A+#define=20=
DS1WM_CMD_DQ_INPUT=20=20(1=20<<=203)=09/*=20read=20only=20-=20reflects=20=
state=20of=20bus=20*/=0A+#define=20DS1WM_CMD_RST=09=20=20=20=20(1=20<<=20=
5)=09/*=20software=20reset=20*/=0A+#define=20DS1WM_CMD_OD=09=20=20=20=20=
(1=20<<=207)=09/*=20overdrive=20*/=0A+=0A+#define=20DS1WM_INT_PD=09=20=20=
=20=20(1=20<<=200)=09/*=20presence=20detect=20*/=0A+#define=20=
DS1WM_INT_PDR=09=20=20=20=20(1=20<<=201)=09/*=20presence=20detect=20=
result=20*/=0A+#define=20DS1WM_INT_TBE=09=20=20=20=20(1=20<<=202)=09/*=20=
tx=20buffer=20empty=20*/=0A+#define=20DS1WM_INT_TSRE=09=20=20=20=20(1=20=
<<=203)=09/*=20tx=20shift=20register=20empty=20*/=0A+#define=20=
DS1WM_INT_RBF=09=20=20=20=20(1=20<<=204)=09/*=20rx=20buffer=20full=20*/=0A=
+#define=20DS1WM_INT_RSRF=09=20=20=20=20(1=20<<=205)=09/*=20rx=20shift=20=
register=20full=20*/=0A+=0A+#define=20DS1WM_INTEN_EPD=09=20=20=20=20(1=20=
<<=200)=09/*=20enable=20presence=20detect=20int=20*/=0A+#define=20=
DS1WM_INTEN_IAS=09=20=20=20=20(1=20<<=201)=09/*=20INTR=20active=20state=20=
*/=0A+#define=20DS1WM_INTEN_ETBE=20=20=20=20(1=20<<=202)=09/*=20enable=20=
tx=20buffer=20empty=20int=20*/=0A+#define=20DS1WM_INTEN_ETMT=20=20=20=20=
(1=20<<=203)=09/*=20enable=20tx=20shift=20register=20empty=20int=20*/=0A=
+#define=20DS1WM_INTEN_ERBF=20=20=20=20(1=20<<=204)=09/*=20enable=20rx=20=
buffer=20full=20int=20*/=0A+#define=20DS1WM_INTEN_ERSRF=20=20=20(1=20<<=20=
5)=09/*=20enable=20rx=20shift=20register=20full=20int=20*/=0A+#define=20=
DS1WM_INTEN_DQO=09=20=20=20=20(1=20<<=206)=09/*=20enable=20direct=20bus=20=
driving=20ops=20*/=0A+=0A+=0A+#define=20DS1WM_TIMEOUT=20(HZ=20*=205)=0A+=0A=
+static=20struct=20{=0A+=09unsigned=20long=20freq;=0A+=09unsigned=20long=20=
divisor;=0A+}=20freq[]=20=3D=20{=0A+=09{=204000000,=200x8=20},=0A+=09{=20=
5000000,=200x2=20},=0A+=09{=206000000,=200x5=20},=0A+=09{=207000000,=20=
0x3=20},=0A+=09{=208000000,=200xc=20},=0A+=09{=2010000000,=200x6=20},=0A=
+=09{=2012000000,=200x9=20},=0A+=09{=2014000000,=200x7=20},=0A+=09{=20=
16000000,=200x10=20},=0A+=09{=2020000000,=200xa=20},=0A+=09{=2024000000,=20=
0xd=20},=0A+=09{=2028000000,=200xb=20},=0A+=09{=2032000000,=200x14=20},=0A=
+=09{=2040000000,=200xe=20},=0A+=09{=2048000000,=200x11=20},=0A+=09{=20=
56000000,=200xf=20},=0A+=09{=2064000000,=200x18=20},=0A+=09{=2080000000,=20=
0x12=20},=0A+=09{=2096000000,=200x15=20},=0A+=09{=20112000000,=200x13=20=
},=0A+=09{=20128000000,=200x1c=20},=0A+};=0A+=0A+struct=20ds1wm_data=20{=0A=
+=09void=09=09*map;=0A+=09int=09=09bus_shift;=20/*=20#=20of=20shifts=20=
to=20calc=20register=20offsets=20*/=0A+=09struct=20platform_device=20=
*pdev;=0A+=09struct=20ds1wm_platform_data=20*pdata;=0A+=09int=09=09irq;=0A=
+=09struct=20clk=09*clk;=0A+=09int=09=09slave_present;=0A+=09void=09=09=
*reset_complete;=0A+=09void=09=09*read_complete;=0A+=09void=09=09=
*write_complete;=0A+=09u8=09=09read_byte;=20/*=20last=20byte=20received=20=
*/=0A+};=0A+=0A+static=20inline=20void=20ds1wm_write_register(struct=20=
ds1wm_data=20*ds1wm_data,=20u32=20reg,=0A+=09=09=09=09=09u8=20val)=0A+{=0A=
+=20=20=20=20=20=20=20=20__raw_writeb(val,=20ds1wm_data->map=20+=20(reg=20=
<<=20ds1wm_data->bus_shift));=0A+}=0A+=0A+static=20inline=20u8=20=
ds1wm_read_register(struct=20ds1wm_data=20*ds1wm_data,=20u32=20reg)=0A+{=0A=
+=20=20=20=20=20=20=20=20return=20__raw_readb(ds1wm_data->map=20+=20(reg=20=
<<=20ds1wm_data->bus_shift));=0A+}=0A+=0A+=0A+static=20irqreturn_t=20=
ds1wm_isr(int=20isr,=20void=20*data)=0A+{=0A+=09struct=20ds1wm_data=20=
*ds1wm_data=20=3D=20data;=0A+=09u8=20intr=20=3D=20=
ds1wm_read_register(ds1wm_data,=20DS1WM_INT);=0A+=0A+=09=
ds1wm_data->slave_present=20=3D=20(intr=20&=20DS1WM_INT_PDR)=20?=200=20:=20=
1;=0A+=0A+=09if=20((intr=20&=20DS1WM_INT_PD)=20&&=20=
ds1wm_data->reset_complete)=0A+=09=09=
complete(ds1wm_data->reset_complete);=0A+=0A+=09if=20((intr=20&=20=
DS1WM_INT_TSRE)=20&&=20ds1wm_data->write_complete)=0A+=09=09=
complete(ds1wm_data->write_complete);=0A+=0A+=09if=20(intr=20&=20=
DS1WM_INT_RBF)=20{=0A+=09=09ds1wm_data->read_byte=20=3D=20=
ds1wm_read_register(ds1wm_data,=0A+=09=09=09=09=09=09=09=20=20=20=20=
DS1WM_DATA);=0A+=09=09if=20(ds1wm_data->read_complete)=0A+=09=09=09=
complete(ds1wm_data->read_complete);=0A+=09}=0A+=0A+=09return=20=
IRQ_HANDLED;=0A+}=0A+=0A+static=20int=20ds1wm_reset(struct=20ds1wm_data=20=
*ds1wm_data)=0A+{=0A+=09unsigned=20long=20timeleft;=0A+=09=
DECLARE_COMPLETION_ONSTACK(reset_done);=0A+=0A+=09=
ds1wm_data->reset_complete=20=3D=20&reset_done;=0A+=0A+=09=
ds1wm_write_register(ds1wm_data,=20DS1WM_INT_EN,=20DS1WM_INTEN_EPD=20|=0A=
+=09=09(ds1wm_data->pdata->active_high=20?=20DS1WM_INTEN_IAS=20:=200));=0A=
+=0A+=09ds1wm_write_register(ds1wm_data,=20DS1WM_CMD,=20=
DS1WM_CMD_1W_RESET);=0A+=0A+=09timeleft=20=3D=20=
wait_for_completion_timeout(&reset_done,=20DS1WM_TIMEOUT);=0A+=09=
ds1wm_data->reset_complete=20=3D=20NULL;=0A+=09if=20(!timeleft)=20{=0A+=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
dev_dbg(&ds1wm_data->pdev->dev,=20"reset=20failed\n");=0A+=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20return=201;=0A+=09}=0A+=0A+=09/*=20Wait=20=
for=20the=20end=20of=20the=20reset.=20According=20to=20the=20specs,=20=
the=20time=0A+=09=20*=20from=20when=20the=20interrupt=20is=20asserted=20=
to=20the=20end=20of=20the=20reset=20is:=0A+=09=20*=20=20=20=20=20tRSTH=20=
=20-=20tPDH=20=20-=20tPDL=20-=20tPDI=0A+=09=20*=20=20=20=20=20625=20us=20=
-=2060=20us=20-=20240=20us=20-=20100=20ns=20=3D=20324.9=20us=0A+=09=20*=0A=
+=09=20*=20We'll=20wait=20a=20bit=20longer=20just=20to=20be=20sure.=0A+=09=
=20*/=0A+=09udelay(500);=0A+=0A+=09ds1wm_write_register(ds1wm_data,=20=
DS1WM_INT_EN,=0A+=09=09DS1WM_INTEN_ERBF=20|=20DS1WM_INTEN_ETMT=20|=20=
DS1WM_INTEN_EPD=20|=0A+=09=09(ds1wm_data->pdata->active_high=20?=20=
DS1WM_INTEN_IAS=20:=200));=0A+=0A+=09if=20(!ds1wm_data->slave_present)=20=
{=0A+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
dev_dbg(&ds1wm_data->pdev->dev,=20"reset:=20no=20devices=20found\n");=0A=
+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20return=201;=0A+=20=20=20=
=20=20=20=20=20}=0A+=0A+=20=20=20=20=20=20=20=20return=200;=0A+}=0A+=0A=
+static=20int=20ds1wm_write(struct=20ds1wm_data=20*ds1wm_data,=20u8=20=
data)=0A+{=0A+=09DECLARE_COMPLETION_ONSTACK(write_done);=0A+=09=
ds1wm_data->write_complete=20=3D=20&write_done;=0A+=0A+=09=
ds1wm_write_register(ds1wm_data,=20DS1WM_DATA,=20data);=0A+=0A+=09=
wait_for_completion_timeout(&write_done,=20DS1WM_TIMEOUT);=0A+=09=
ds1wm_data->write_complete=20=3D=20NULL;=0A+=0A+=09return=200;=0A+}=0A+=0A=
+static=20int=20ds1wm_read(struct=20ds1wm_data=20*ds1wm_data,=20unsigned=20=
char=20write_data)=0A+{=0A+=09DECLARE_COMPLETION_ONSTACK(read_done);=0A+=09=
ds1wm_data->read_complete=20=3D=20&read_done;=0A+=0A+=09=
ds1wm_write(ds1wm_data,=20write_data);=0A+=09=
wait_for_completion_timeout(&read_done,=20DS1WM_TIMEOUT);=0A+=09=
ds1wm_data->read_complete=20=3D=20NULL;=0A+=0A+=09return=20=
ds1wm_data->read_byte;=0A+}=0A+=0A+static=20int=20ds1wm_find_divisor(int=20=
gclk)=0A+{=0A+=09int=20i;=0A+=0A+=09for=20(i=20=3D=200;=20i=20<=20=
ARRAY_SIZE(freq);=20i++)=0A+=09=09if=20(gclk=20<=3D=20freq[i].freq)=0A+=09=
=09=09return=20freq[i].divisor;=0A+=0A+=09return=200;=0A+}=0A+=0A+static=20=
void=20ds1wm_up(struct=20ds1wm_data=20*ds1wm_data)=0A+{=0A+=09int=20=
gclk,=20divisor;=0A+=09=0A+=09if=20(ds1wm_data->pdata->enable)=0A+=09=09=
ds1wm_data->pdata->enable(ds1wm_data->pdev);=0A+=0A+=09gclk=20=3D=20=
clk_get_rate(ds1wm_data->clk);=0A+=09clk_enable(ds1wm_data->clk);=0A+=09=
divisor=20=3D=20ds1wm_find_divisor(gclk);=0A+=09if=20(divisor=20=3D=3D=20=
0)=20{=0A+=09=09dev_err(&ds1wm_data->pdev->dev,=0A+=09=09=09"no=20=
suitable=20divisor=20for=20%dHz=20clock\n",=20gclk);=0A+=09=09return;=0A=
+=09}=0A+=09ds1wm_write_register(ds1wm_data,=20DS1WM_CLKDIV,=20divisor);=0A=
+=0A+=09/*=20Let=20the=20w1=20clock=20stabilize.=20*/=0A+=09msleep(1);=0A=
+=0A+=09ds1wm_reset(ds1wm_data);=0A+}=0A+=0A+static=20void=20=
ds1wm_down(struct=20ds1wm_data=20*ds1wm_data)=0A+{=0A+=09=
ds1wm_reset(ds1wm_data);=0A+=0A+=09if=20(ds1wm_data->pdata->disable)=0A+=09=
=09ds1wm_data->pdata->disable(ds1wm_data->pdev);=0A+=0A+=09=
clk_disable(ds1wm_data->clk);=0A+}=0A+=0A+/*=20=
---------------------------------------------------------------------=20=
*/=0A+/*=20w1=20methods=20*/=0A+=0A+static=20u8=20ds1wm_read_byte(void=20=
*data)=0A+{=0A+=09struct=20ds1wm_data=20*ds1wm_data=20=3D=20data;=0A+=0A=
+=09return=20ds1wm_read(ds1wm_data,=200xff);=0A+}=0A+=0A+static=20void=20=
ds1wm_write_byte(void=20*data,=20u8=20byte)=0A+{=0A+=09struct=20=
ds1wm_data=20*ds1wm_data=20=3D=20data;=0A+=0A+=09ds1wm_write(ds1wm_data,=20=
byte);=0A+}=0A+=0A+static=20u8=20ds1wm_reset_bus(void=20*data)=0A+{=0A+=09=
struct=20ds1wm_data=20*ds1wm_data=20=3D=20data;=0A+=0A+=09=
ds1wm_reset(ds1wm_data);=0A+=0A+=09return=200;=0A+}=0A+=0A+static=20void=20=
ds1wm_search(void=20*data,=20u8=20search_type,=0A+=09=09=09=20=
w1_slave_found_callback=20slave_found)=0A+{=0A+=09struct=20ds1wm_data=20=
*ds1wm_data=20=3D=20data;=0A+=09int=20i;=0A+=09unsigned=20long=20long=20=
rom_id;=0A+=0A+=09/*=20XXX=20We=20need=20to=20iterate=20for=20multiple=20=
devices=20per=20the=20DS1WM=20docs.=0A+=09=20*=20See=20=
http://www.maxim-ic.com/appnotes.cfm/appnote_number/120.=20*/=0A+=09if=20=
(ds1wm_reset(ds1wm_data))=0A+=09=09return;=0A+=09=0A+=09=
ds1wm_write(ds1wm_data,=20search_type);=0A+=09=
ds1wm_write_register(ds1wm_data,=20DS1WM_CMD,=20DS1WM_CMD_SRA);=0A+=0A+=09=
for=20(rom_id=20=3D=200,=20i=20=3D=200;=20i=20<=2016;=20i++)=20{=0A+=0A+=09=
=09unsigned=20char=20resp,=20r,=20d;=0A+=0A+=09=09resp=20=3D=20=
ds1wm_read(ds1wm_data,=200x00);=0A+=0A+=09=09r=20=3D=20((resp=20&=20=
0x02)=20>>=201)=20|=0A+=09=09=20=20=20=20((resp=20&=200x08)=20>>=202)=20=
|=0A+=09=09=20=20=20=20((resp=20&=200x20)=20>>=203)=20|=0A+=09=09=20=20=20=
=20((resp=20&=200x80)=20>>=204);=0A+=0A+=09=09d=20=3D=20((resp=20&=20=
0x01)=20>>=200)=20|=0A+=09=09=20=20=20=20((resp=20&=200x04)=20>>=201)=20=
|=0A+=09=09=20=20=20=20((resp=20&=200x10)=20>>=202)=20|=0A+=09=09=20=20=20=
=20((resp=20&=200x40)=20>>=203);=0A+=0A+=09=09rom_id=20|=3D=20(unsigned=20=
long=20long)=20r=20<<=20(i=20*=204);=0A+=0A+=09}=0A+=09=
dev_dbg(&ds1wm_data->pdev->dev,=20"found=200x%08llX",=20rom_id);=0A+=0A+=09=
ds1wm_write_register(ds1wm_data,=20DS1WM_CMD,=20~DS1WM_CMD_SRA);=0A+=09=
ds1wm_reset(ds1wm_data);=0A+=0A+=09slave_found(ds1wm_data,=20rom_id);=0A=
+}=0A+=0A+/*=20=
---------------------------------------------------------------------=20=
*/=0A+=0A+static=20struct=20w1_bus_master=20ds1wm_master=20=3D=20{=0A+=09=
.read_byte=20=20=3D=20ds1wm_read_byte,=0A+=09.write_byte=20=3D=20=
ds1wm_write_byte,=0A+=09.reset_bus=20=20=3D=20ds1wm_reset_bus,=0A+=09=
.search=09=20=20=20=20=3D=20ds1wm_search,=0A+};=0A+=0A+static=20int=20=
ds1wm_probe(struct=20platform_device=20*pdev)=0A+{=0A+=09struct=20=
ds1wm_data=20*ds1wm_data;=0A+=09struct=20ds1wm_platform_data=20*plat;=0A=
+=09struct=20resource=20*res;=0A+=09int=20ret;=0A+=0A+=09if=20(!pdev)=0A=
+=09=09return=20-ENODEV;=0A+=0A+=09ds1wm_data=20=3D=20kzalloc(sizeof=20=
(*ds1wm_data),=20GFP_KERNEL);=0A+=09if=20(!ds1wm_data)=0A+=09=09return=20=
-ENOMEM;=0A+=0A+=09platform_set_drvdata(pdev,=20ds1wm_data);=0A+=0A+=09=
res=20=3D=20platform_get_resource(pdev,=20IORESOURCE_MEM,=200);=0A+=09if=20=
(!res)=20{=0A+=09=09ret=20=3D=20-ENXIO;=0A+=09=09goto=20err0;=0A+=09}=0A=
+=09ds1wm_data->map=20=3D=20ioremap(res->start,=20res->end=20-=20=
res->start=20+=201);=0A+=09if=20(!ds1wm_data->map)=20{=0A+=09=09ret=20=3D=20=
-ENOMEM;=0A+=09=09goto=20err0;=0A+=09}=0A+=09plat=20=3D=20=
pdev->dev.platform_data;=0A+=09ds1wm_data->bus_shift=20=3D=20=
plat->bus_shift;=0A+=09ds1wm_data->pdev=20=3D=20pdev;=0A+=09=
ds1wm_data->pdata=20=3D=20plat;=0A+=0A+=09res=20=3D=20=
platform_get_resource(pdev,=20IORESOURCE_IRQ,=200);=0A+=09if=20(!res)=20=
{=0A+=09=09ret=20=3D=20-ENXIO;=0A+=09=09goto=20err1;=0A+=09}=0A+=09=
ds1wm_data->irq=20=3D=20res->start;=0A+=0A+=09=
set_irq_type(ds1wm_data->irq,=20res->flags=20&=20IORESOURCE_IRQ_LOWEDGE=20=
?=0A+=09=09=09IRQ_TYPE_EDGE_FALLING=20:=20IRQ_TYPE_EDGE_RISING);=0A+=0A+=09=
ret=20=3D=20request_irq(ds1wm_data->irq,=20ds1wm_isr,=20IRQF_DISABLED,=0A=
+=09=09=09=20=20"ds1wm",=20ds1wm_data);=0A+=09if=20(ret)=0A+=09=09goto=20=
err1;=0A+=0A+=09ds1wm_data->clk=20=3D=20clk_get(&pdev->dev,=20"ds1wm");=0A=
+=09if=20(!ds1wm_data->clk)=20{=0A+=09=09ret=20=3D=20-ENOENT;=0A+=09=09=
goto=20err2;=0A+=09}=0A+=0A+=09ds1wm_up(ds1wm_data);=0A+=0A+=09=
ds1wm_master.data=20=3D=20(void=20*)ds1wm_data;=0A+=0A+=09ret=20=3D=20=
w1_add_master_device(&ds1wm_master);=0A+=09if=20(ret)=0A+=09=09goto=20=
err3;=0A+=0A+=09return=200;=0A+=0A+err3:=0A+=09ds1wm_down(ds1wm_data);=0A=
+=09clk_put(ds1wm_data->clk);=0A+err2:=0A+=09free_irq(ds1wm_data->irq,=20=
ds1wm_data);=0A+err1:=0A+=09iounmap(ds1wm_data->map);=0A+err0:=0A+=09=
kfree(ds1wm_data);=0A+=0A+=09return=20ret;=0A+}=0A+=0A+#ifdef=20=
CONFIG_PM=0A+static=20int=20ds1wm_suspend(struct=20platform_device=20=
*pdev,=20pm_message_t=20state)=0A+{=0A+=09struct=20ds1wm_data=20=
*ds1wm_data=20=3D=20platform_get_drvdata(pdev);=0A+=0A+=09=
ds1wm_down(ds1wm_data);=0A+=0A+=09return=200;=0A+}=0A+=0A+static=20int=20=
ds1wm_resume(struct=20platform_device=20*pdev)=0A+{=0A+=09struct=20=
ds1wm_data=20*ds1wm_data=20=3D=20platform_get_drvdata(pdev);=0A+=0A+=09=
ds1wm_up(ds1wm_data);=0A+=0A+=09return=200;=0A+}=0A+#else=0A+#define=20=
ds1wm_suspend=20NULL=0A+#define=20ds1wm_resume=20NULL=0A+#endif=0A+=0A=
+static=20int=20ds1wm_remove(struct=20platform_device=20*pdev)=0A+{=0A+=09=
struct=20ds1wm_data=20*ds1wm_data=20=3D=20platform_get_drvdata(pdev);=0A=
+=0A+=09w1_remove_master_device(&ds1wm_master);=0A+=09=
ds1wm_down(ds1wm_data);=0A+=09clk_put(ds1wm_data->clk);=0A+=09=
free_irq(ds1wm_data->irq,=20ds1wm_data);=0A+=09iounmap(ds1wm_data->map);=0A=
+=09kfree(ds1wm_data);=0A+=0A+=09return=200;=0A+}=0A+=0A+static=20struct=20=
platform_driver=20ds1wm_driver=20=3D=20{=0A+=09.driver=20=20=20=3D=20{=0A=
+=09=09.name=20=3D=20"ds1wm",=0A+=09},=0A+=09.probe=20=20=20=20=3D=20=
ds1wm_probe,=0A+=09.remove=20=20=20=3D=20ds1wm_remove,=0A+=09.suspend=20=20=
=3D=20ds1wm_suspend,=0A+=09.resume=20=20=20=3D=20ds1wm_resume=0A+};=0A+=0A=
+static=20int=20__init=20ds1wm_init(void)=0A+{=0A+=09printk("DS1WM=20w1=20=
busmaster=20driver=20-=20(c)=202004=20Szabolcs=20Gyurko\n");=0A+=09=
return=20platform_driver_register(&ds1wm_driver);=0A+}=0A+=0A+static=20=
void=20__exit=20ds1wm_exit(void)=0A+{=0A+=09=
platform_driver_unregister(&ds1wm_driver);=0A+}=0A+=0A=
+module_init(ds1wm_init);=0A+module_exit(ds1wm_exit);=0A+=0A=
+MODULE_LICENSE("GPL");=0A+MODULE_AUTHOR("Szabolcs=20Gyurko=20=
<szabolcs.gyurko@tlt.hu>,=20"=0A+=09=20=20=20=20=20=20"Matt=20Reimer=20=
<mreimer@vpop.net>");=0A+MODULE_DESCRIPTION("DS1WM=20w1=20busmaster=20=
driver");=0Adiff=20--git=20a/include/linux/ds1wm.h=20=
b/include/linux/ds1wm.h=0Anew=20file=20mode=20100644=0Aindex=20=
0000000..feeb64d=0A---=20/dev/null=0A+++=20b/include/linux/ds1wm.h=0A@@=20=
-0,0=20+1,12=20@@=0A+/*=20platform=20data=20for=20the=20DS1WM=20driver=20=
*/=0A+=0A+struct=20ds1wm_platform_data=20{=0A+=09int=20bus_shift;=09=20=20=
=20=20/*=20number=20of=20shifts=20needed=20to=20calculate=20the=0A+=09=09=
=09=20=20=20=20=20*=20offset=20between=20DS1WM=20registers;=0A+=09=09=09=20=
=20=20=20=20*=20e.g.=20on=20h5xxx=20and=20h2200=20this=20is=202=0A+=09=09=
=09=20=20=20=20=20*=20(registers=20aligned=20to=204-byte=20boundaries),=0A=
+=09=09=09=20=20=20=20=20*=20while=20on=20hx4700=20this=20is=201=20*/=0A=
+=09int=20active_high;=20=20=20=20/*=20interrupt=20polarity,=20passed=20=
to=20DS1WM=20as=20IAS=20bit=20*/=0A+=09void=20(*enable)(struct=20=
platform_device=20*pdev);=0A+=09void=20(*disable)(struct=20=
platform_device=20*pdev);=0A+};=0A--=20=0A1.5.1.1=0A=0A=

--Apple-Mail-1--417236537--
